#include "printf.h"
#include "trap.h"
#include "mul.h"
#include "div.h"
#include "perf_cnt.h"

#define FRAC_BIT		10

#define RD_ADDR			135106448
#define RD_SIZE_D0		1
#define RD_SIZE_D1		1
#define RD_SIZE_D2		28
#define RD_SIZE_D3		28

#define WEIGHT_ADDR		134217728
#define WEIGHT_SIZE_D0	20		
#define WEIGHT_SIZE_D1	1
#define WEIGHT_SIZE_D2	5
#define WEIGHT_SIZE_D3	5

#define WR_ADDR			135108240
#define WR_SIZE_D0		1
#define WR_SIZE_D1		20
#define WR_SIZE_D2		12
#define WR_SIZE_D3		12

#define KERN_ATTR_CONV_PAD			0
#define KERN_ATTR_CONV_STRIDE		1
#define KERN_ATTR_POOL_PAD			0
#define KERN_ATTR_POOL_KERN_SIZE	2
#define KERN_ATTR_POOL_STRIDE		2

struct size_vec4 {
	unsigned d0;
	unsigned d1;
	unsigned d2;
	unsigned d3;
};

struct mem_addr {
	unsigned rd_addr;
	unsigned weight_addr;
	unsigned wr_addr;
};

int mul(short a,short b) {
	return (int)a*b;
	//return mul_ll(a,b);
}

struct mem_addr addr = {RD_ADDR, WEIGHT_ADDR, WR_ADDR};
struct size_vec4 rd_size = {RD_SIZE_D0, RD_SIZE_D1, RD_SIZE_D2, RD_SIZE_D3};
struct size_vec4 wr_size = {WR_SIZE_D0, WR_SIZE_D1, WR_SIZE_D2, WR_SIZE_D3};
struct size_vec4 weight_size = {WEIGHT_SIZE_D0, WEIGHT_SIZE_D1, WEIGHT_SIZE_D2, WEIGHT_SIZE_D3};
	
struct size_vec4 conv_size;

void convolution() {
	short* in = (short*)addr.rd_addr;
	short* weight = (short*)addr.weight_addr;
	short* out = (short*)addr.wr_addr;

	unsigned output_offset = 0;
	unsigned input_offset = 0;
	
	unsigned input_fm_w = rd_size.d3;
	unsigned input_fm_h = rd_size.d2;

	unsigned pad = KERN_ATTR_CONV_PAD;
	unsigned pad_len = pad << 1;
	
	unsigned conv_out_w = rd_size.d3 - weight_size.d3 + pad_len;
	unsigned conv_out_h = rd_size.d2 - weight_size.d2 + pad_len;

	unsigned stride = KERN_ATTR_CONV_STRIDE;

	conv_out_w = div(conv_out_w, stride);
	conv_out_h = div(conv_out_h, stride);

	conv_out_w++;
	conv_out_h++;

	conv_size.d0 = wr_size.d0;
	conv_size.d1 = wr_size.d1;
	conv_size.d2 = conv_out_h;
	conv_size.d3 = conv_out_w;
	
	//TODO: Please add your own algorithm implementaion here

	int no,ni,x,y,ky,kx;
	int in_size=mul(input_fm_w,input_fm_h);
	int filter_size=mul(weight_size.d2,weight_size.d3)+1;
	int out_size=mul(conv_size.d2,conv_size.d3);
	
	volatile char* test = (void *)0x0000000C;
	*(test)=0;
	for(no=0;no<mul(conv_size.d1,conv_size.d0);no++){
		for(ni=0;ni<rd_size.d1;ni++){
			for(y=0;y<conv_size.d2;y++)
				for(x=0;x<conv_size.d3;x++){
					int baseX=mul(x,stride)-pad;
					int baseY=mul(y,stride)-pad;
					
					input_offset=mul(ni,in_size)+mul(baseY,input_fm_w)+baseX;
					output_offset=mul(no,out_size)+mul(y,conv_size.d3)+x;
					int weight_offset=mul(no,mul(weight_size.d1,filter_size))+mul(ni,filter_size)+1;
					int ans=0;
					if(ni==0)
						*(out+output_offset)=*(weight+weight_offset-1);
					for(ky=0;ky<weight_size.d2;ky++)						
						for(kx=0;kx<weight_size.d3;kx++,weight_offset++){
							short temp=((baseY+ky)<0||(baseY+ky)>=input_fm_h||(baseX+kx)<0||(baseX+kx)>=input_fm_w)?0:*(in+mul(ky,input_fm_w)+kx+input_offset);
							ans+=mul(temp,*(weight+weight_offset));
						}
					*(out+output_offset)+=(short)(ans>>FRAC_BIT);
				}
		}
	}
		
	
}

void pooling() {
	short* out = (short*)addr.wr_addr;
	
	unsigned output_offset = 0;
	unsigned input_offset = 0;
	
	unsigned input_fm_w = conv_size.d3;
	unsigned input_fm_h = conv_size.d2;
	
	unsigned pad = KERN_ATTR_POOL_PAD;
	unsigned pad_len = pad << 1;
	
	unsigned pad_w_test = conv_size.d3 - KERN_ATTR_POOL_KERN_SIZE;
	unsigned pad_h_test = conv_size.d2 - KERN_ATTR_POOL_KERN_SIZE;

	unsigned pool_out_w = pad_w_test + pad_len;
	unsigned pool_out_h = pad_h_test + pad_len;

	unsigned stride = KERN_ATTR_POOL_STRIDE;

	unsigned pad_w_test_remain = pad_w_test - mul(div(pad_w_test, stride), stride);
	unsigned pad_h_test_remain = pad_h_test - mul(div(pad_h_test, stride), stride);

	pool_out_w = div(pool_out_w, stride);
	pool_out_h = div(pool_out_h, stride);
	pool_out_w++;
	pool_out_h++;

	if ( (!pad) && (pad_w_test_remain || pad_h_test_remain) )
	{
		pool_out_w++;
		pool_out_h++;
	}
	
	//TODO: Please add your own algorithm implementaion here

	int no,x,y,ix,iy;
	short max,comp;
	int in_size=mul(input_fm_h,input_fm_w);
	int out_size=mul(pool_out_h,pool_out_w);
	int kern_size=KERN_ATTR_POOL_KERN_SIZE;
	for(no=0;no<mul(wr_size.d1,wr_size.d0);no++){
		for(x=0;x<pool_out_h;x++)
			for(y=0;y<pool_out_w;y++){
				int baseX=mul(x,stride);
				int baseY=mul(y,stride);
				input_offset=mul(no,in_size)+mul(baseX,input_fm_w)+baseY;
				output_offset=mul(no,out_size)+mul(x,pool_out_w)+y;
				max=*(out+input_offset);
				for(ix=0;ix<kern_size;ix++)
					for(iy=0;iy<kern_size;iy++){

						if((ix+baseX)<0 || (ix+baseX)>=input_fm_w || (iy+baseY)<0 || (iy+baseY)>=input_fm_h) ;
						else{
							comp=*(out+input_offset+mul(ix,input_fm_w)+iy);	
							if(comp>max){
								max=comp;						
							}
						}
					}
				*(out+output_offset)=max;			
			}			
		
	} 



}

int main()
{
	Result res;
	res.msec=0;
	bench_prepare(&res);
	printf("starting convolution\n");
	
	convolution();
	
	printf("starting pooling\n");
	pooling();
	
	bench_done(&res);
	printf("total cycle %d\n",res.msec);
	return 0;
}
