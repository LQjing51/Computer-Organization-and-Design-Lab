(this.webpackJsonp=this.webpackJsonp||[]).push([[3,116,382],{"4ips":function(t,e,n){var r=n("1qE/"),o=n("MlCX");t.exports=function t(e,n,a,s,i){var c=-1,l=e.length;for(a||(a=o),i||(i=[]);++c<l;){var u=e[c];n>0&&a(u)?n>1?t(u,n-1,a,s,i):r(i,u):s||(i[i.length]=u)}return i}},"8Doe":function(t,e,n){var r=n("4ips");t.exports=function(t){return(null==t?0:t.length)?r(t,1):[]}},CX32:function(t,e,n){"use strict";n.d(e,"a",(function(){return i}));var r=n("t6Yz"),o=n.n(r),a=n("yQ8t"),s=n("v+Mp");class i extends s.default{constructor(){super(),o.a.bind("g p",(function(){return Object(a.a)(".shortcuts-project")})),o.a.bind("g v",(function(){return Object(a.a)(".shortcuts-project-activity")})),o.a.bind("g r",(function(){return Object(a.a)(".shortcuts-project-releases")})),o.a.bind("g f",(function(){return Object(a.a)(".shortcuts-tree")})),o.a.bind("g c",(function(){return Object(a.a)(".shortcuts-commits")})),o.a.bind("g j",(function(){return Object(a.a)(".shortcuts-builds")})),o.a.bind("g n",(function(){return Object(a.a)(".shortcuts-network")})),o.a.bind("g d",(function(){return Object(a.a)(".shortcuts-repository-charts")})),o.a.bind("g i",(function(){return Object(a.a)(".shortcuts-issues")})),o.a.bind("g b",(function(){return Object(a.a)(".shortcuts-issue-boards")})),o.a.bind("g m",(function(){return Object(a.a)(".shortcuts-merge_requests")})),o.a.bind("g w",(function(){return Object(a.a)(".shortcuts-wiki")})),o.a.bind("g s",(function(){return Object(a.a)(".shortcuts-snippets")})),o.a.bind("g k",(function(){return Object(a.a)(".shortcuts-kubernetes")})),o.a.bind("g e",(function(){return Object(a.a)(".shortcuts-environments")})),o.a.bind("g l",(function(){return Object(a.a)(".shortcuts-metrics")})),o.a.bind("i",(function(){return Object(a.a)(".shortcuts-new-issue")}))}}},FkSe:function(t,e,n){"use strict";var r=n("Pyw5"),o=["sm","md","lg","xl"],a={dark:"dark",light:"light"};const s={props:{label:{type:String,required:!1,default:"Loading"},size:{type:String,required:!1,default:"sm",validator:function(t){return-1!==o.indexOf(t)}},color:{type:String,required:!1,default:a.dark,validator:function(t){return Object.keys(a).includes(t)}},inline:{type:Boolean,required:!1,default:!1}},computed:{rootElementType:function(){return this.inline?"span":"div"},cssClasses:function(){return["gl-spinner","".concat("gl-spinner","-").concat(a[this.color]),"".concat("gl-spinner","-").concat(this.size)]}}};const i=n.n(r)()({render:function(){var t=this.$createElement,e=this._self._c||t;return e(this.rootElementType,{tag:"component",staticClass:"gl-spinner-container"},[e("span",{staticClass:"align-text-bottom",class:this.cssClasses,attrs:{"aria-label":this.label}})])},staticRenderFns:[]},void 0,s,void 0,!1,void 0,!1,void 0,void 0,void 0);e.a=i},MlCX:function(t,e,n){var r=n("aCzx"),o=n("x14d"),a=n("P/Kr"),s=r?r.isConcatSpreadable:void 0;t.exports=function(t){return a(t)||o(t)||!!(s&&t&&t[s])}},U6io:function(t,e){!function(t){var e=t.prototype.stopCallback;t.prototype.stopCallback=function(t,n,r){return!!this.paused||e.call(this,t,n,r)},t.prototype.pause=function(){this.paused=!0},t.prototype.unpause=function(){this.paused=!1},t.init()}(Mousetrap)},j00k:function(t,e,n){"use strict";var r=n("s1D3"),o=n("FkSe"),a=n("Pyw5"),s=n.n(a);const i={components:{GlIcon:r.a,GlLoadingIcon:o.a},model:{prop:"value",event:"change"},props:{name:{type:String,required:!1,default:null},value:{type:Boolean,required:!1,default:null},disabled:{type:Boolean,required:!1,default:!1},isLoading:{type:Boolean,required:!1,default:!1},label:{type:String,required:!1,default:void 0},help:{type:String,required:!1,default:void 0},ariaDescribedby:{type:String,required:!1,default:void 0},labelPosition:{type:String,required:!1,default:"top",validator:function(t){return["hidden","top","left"].includes(t)}}},computed:{ariaLabel:function(){return"hidden"===this.labelPosition?this.labelText:void 0},icon:function(){return this.value?"mobile-issue-close":"close"}},methods:{toggleFeature:function(){this.disabled||this.$emit("change",!this.value)}}};const c=s()({render:function(){var t=this,e=t.$createElement,n=t._self._c||e;return n("label",{staticClass:"gl-display-flex gl-flex-direction-column gl-mb-0 gl-w-max-content"},[n("div",{staticClass:"gl-toggle-wrapper",class:{"gl-toggle-label-inline":"left"===t.labelPosition,"is-disabled":t.disabled}},[t.label?n("span",{staticClass:"gl-toggle-label"},[t._t("label",[t._v(t._s(t.label))])],2):t._e(),t._v(" "),t.name?n("input",{attrs:{name:t.name,type:"hidden"},domProps:{value:t.value}}):t._e(),t._v(" "),n("button",{class:{"gl-toggle":!0,"is-checked":t.value,"is-disabled":t.disabled},attrs:{"aria-label":t.label,"aria-describedby":t.help,type:"button"},on:{click:function(e){return e.preventDefault(),t.toggleFeature(e)}}},[t.isLoading?n("gl-loading-icon",{staticClass:"toggle-loading",attrs:{color:"light"}}):n("span",{class:{"toggle-icon":!0,disabled:t.disabled}},[n("gl-icon",{attrs:{name:t.icon,size:16}})],1)],1)]),t._v(" "),t.help?n("span",{staticClass:"gl-help-label"},[t._t("help",[t._v(t._s(t.help))])],2):t._e()])},staticRenderFns:[]},void 0,i,void 0,!1,void 0,!1,void 0,void 0,void 0);e.a=c},t6Yz:function(t,e,n){var r;!function(o,a,s){if(o){for(var i,c={8:"backspace",9:"tab",13:"enter",16:"shift",17:"ctrl",18:"alt",20:"capslock",27:"esc",32:"space",33:"pageup",34:"pagedown",35:"end",36:"home",37:"left",38:"up",39:"right",40:"down",45:"ins",46:"del",91:"meta",93:"meta",224:"meta"},l={106:"*",107:"+",109:"-",110:".",111:"/",186:";",187:"=",188:",",189:"-",190:".",191:"/",192:"`",219:"[",220:"\\",221:"]",222:"'"},u={"~":"`","!":"1","@":"2","#":"3",$:"4","%":"5","^":"6","&":"7","*":"8","(":"9",")":"0",_:"-","+":"=",":":";",'"':"'","<":",",">":".","?":"/","|":"\\"},d={option:"alt",command:"meta",return:"enter",escape:"esc",plus:"+",mod:/Mac|iPod|iPhone|iPad/.test(navigator.platform)?"meta":"ctrl"},f=1;f<20;++f)c[111+f]="f"+f;for(f=0;f<=9;++f)c[f+96]=f.toString();y.prototype.bind=function(t,e,n){return t=t instanceof Array?t:[t],this._bindMultiple.call(this,t,e,n),this},y.prototype.unbind=function(t,e){return this.bind.call(this,t,(function(){}),e)},y.prototype.trigger=function(t,e){return this._directMap[t+":"+e]&&this._directMap[t+":"+e]({},t),this},y.prototype.reset=function(){return this._callbacks={},this._directMap={},this},y.prototype.stopCallback=function(t,e){if((" "+e.className+" ").indexOf(" mousetrap ")>-1)return!1;if(function t(e,n){return null!==e&&e!==a&&(e===n||t(e.parentNode,n))}(e,this.target))return!1;if("composedPath"in t&&"function"==typeof t.composedPath){var n=t.composedPath()[0];n!==t.target&&(e=n)}return"INPUT"==e.tagName||"SELECT"==e.tagName||"TEXTAREA"==e.tagName||e.isContentEditable},y.prototype.handleKey=function(){var t=this;return t._handleKey.apply(t,arguments)},y.addKeycodes=function(t){for(var e in t)t.hasOwnProperty(e)&&(c[e]=t[e]);i=null},y.init=function(){var t=y(a);for(var e in t)"_"!==e.charAt(0)&&(y[e]=function(e){return function(){return t[e].apply(t,arguments)}}(e))},y.init(),o.Mousetrap=y,t.exports&&(t.exports=y),void 0===(r=function(){return y}.call(e,n,e,t))||(t.exports=r)}function p(t,e,n){t.addEventListener?t.addEventListener(e,n,!1):t.attachEvent("on"+e,n)}function h(t){if("keypress"==t.type){var e=String.fromCharCode(t.which);return t.shiftKey||(e=e.toLowerCase()),e}return c[t.which]?c[t.which]:l[t.which]?l[t.which]:String.fromCharCode(t.which).toLowerCase()}function b(t){return"shift"==t||"ctrl"==t||"alt"==t||"meta"==t}function g(t,e,n){return n||(n=function(){if(!i)for(var t in i={},c)t>95&&t<112||c.hasOwnProperty(t)&&(i[c[t]]=t);return i}()[t]?"keydown":"keypress"),"keypress"==n&&e.length&&(n="keydown"),n}function m(t,e){var n,r,o,a=[];for(n=function(t){return"+"===t?["+"]:(t=t.replace(/\+{2}/g,"+plus")).split("+")}(t),o=0;o<n.length;++o)r=n[o],d[r]&&(r=d[r]),e&&"keypress"!=e&&u[r]&&(r=u[r],a.push("shift")),b(r)&&a.push(r);return{key:r,modifiers:a,action:e=g(r,a,e)}}function y(t){var e=this;if(t=t||a,!(e instanceof y))return new y(t);e.target=t,e._callbacks={},e._directMap={};var n,r={},o=!1,s=!1,i=!1;function c(t){t=t||{};var e,n=!1;for(e in r)t[e]?n=!0:r[e]=0;n||(i=!1)}function l(t,n,o,a,s,i){var c,l,u,d,f=[],p=o.type;if(!e._callbacks[t])return[];for("keyup"==p&&b(t)&&(n=[t]),c=0;c<e._callbacks[t].length;++c)if(l=e._callbacks[t][c],(a||!l.seq||r[l.seq]==l.level)&&p==l.action&&("keypress"==p&&!o.metaKey&&!o.ctrlKey||(u=n,d=l.modifiers,u.sort().join(",")===d.sort().join(",")))){var h=!a&&l.combo==s,g=a&&l.seq==a&&l.level==i;(h||g)&&e._callbacks[t].splice(c,1),f.push(l)}return f}function u(t,n,r,o){e.stopCallback(n,n.target||n.srcElement,r,o)||!1===t(n,r)&&(function(t){t.preventDefault?t.preventDefault():t.returnValue=!1}(n),function(t){t.stopPropagation?t.stopPropagation():t.cancelBubble=!0}(n))}function d(t){"number"!=typeof t.which&&(t.which=t.keyCode);var n=h(t);n&&("keyup"!=t.type||o!==n?e.handleKey(n,function(t){var e=[];return t.shiftKey&&e.push("shift"),t.altKey&&e.push("alt"),t.ctrlKey&&e.push("ctrl"),t.metaKey&&e.push("meta"),e}(t),t):o=!1)}function f(t,e,a,s){function l(e){return function(){i=e,++r[t],clearTimeout(n),n=setTimeout(c,1e3)}}function d(e){u(a,e,t),"keyup"!==s&&(o=h(e)),setTimeout(c,10)}r[t]=0;for(var f=0;f<e.length;++f){var p=f+1===e.length?d:l(s||m(e[f+1]).action);g(e[f],p,s,t,f)}}function g(t,n,r,o,a){e._directMap[t+":"+r]=n;var s,i=(t=t.replace(/\s+/g," ")).split(" ");i.length>1?f(t,i,n,r):(s=m(t,r),e._callbacks[s.key]=e._callbacks[s.key]||[],l(s.key,s.modifiers,{type:s.action},o,t,a),e._callbacks[s.key][o?"unshift":"push"]({callback:n,modifiers:s.modifiers,action:s.action,seq:o,level:a,combo:t}))}e._handleKey=function(t,e,n){var r,o=l(t,e,n),a={},d=0,f=!1;for(r=0;r<o.length;++r)o[r].seq&&(d=Math.max(d,o[r].level));for(r=0;r<o.length;++r)if(o[r].seq){if(o[r].level!=d)continue;f=!0,a[o[r].seq]=1,u(o[r].callback,n,o[r].combo,o[r].seq)}else f||u(o[r].callback,n,o[r].combo);var p="keypress"==n.type&&s;n.type!=i||b(t)||p||c(a),s=f&&"keydown"==n.type},e._bindMultiple=function(t,e,n){for(var r=0;r<t.length;++r)g(t[r],e,n)},p(t,"keypress",d),p(t,"keydown",d),p(t,"keyup",d)}}("undefined"!=typeof window?window:null,"undefined"!=typeof window?document:null)},"v+Mp":function(t,e,n){"use strict";n.r(e),n.d(e,"default",(function(){return H}));n("QifN"),n("Tznw"),n("6yen"),n("OeRx"),n("l/dT"),n("RqS2"),n("Zy7a"),n("cjZU"),n("OAhk"),n("X42P"),n("mHhP"),n("fn0I"),n("UB/6"),n("imhG"),n("orcL");var r=n("8Doe"),o=n.n(r),a=n("3a3M"),s=n.n(a),i=n("06tH"),c=n.n(i),l=n("t6Yz"),u=n.n(l),d=n("jB52");n("U6io");const f="shortcutsDisabled",p=function(){try{return"true"===localStorage.getItem(f)}catch(t){return!1}};function h(){localStorage.setItem(f,!0),u.a.pause()}var b=n("j00k"),g=n("n7CP"),m={components:{GlToggle:b.a},data:()=>({localStorageUsable:g.a.isLocalStorageAccessSafe(),shortcutsEnabled:!p()}),methods:{onChange(t){this.shortcutsEnabled=t,t?(localStorage.setItem(f,!1),u.a.unpause()):h()}}},y=n("tBpV"),v=Object(y.a)(m,(function(){var t=this,e=t.$createElement,n=t._self._c||e;return t.localStorageUsable?n("div",{staticClass:"d-inline-flex align-items-center js-toggle-shortcuts"},[n("gl-toggle",{attrs:{"aria-describedby":"shortcutsToggle",label:"Keyboard shortcuts","label-position":"left"},on:{change:t.onChange},model:{value:t.shortcutsEnabled,callback:function(e){t.shortcutsEnabled=e},expression:"shortcutsEnabled"}}),t._v(" "),n("div",{staticClass:"sr-only",attrs:{id:"shortcutsToggle"}},[t._v(t._s(t.__("Enable or disable keyboard shortcuts")))])],1):t._e()}),[],!1,null,null,null).exports,k=n("2ibD"),j=n("3twG"),O=n("yQ8t"),w=n("NmEs"),_=n("/lV4");function S(t,e){var n=Object.keys(t);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(t);e&&(r=r.filter((function(e){return Object.getOwnPropertyDescriptor(t,e).enumerable}))),n.push.apply(n,r)}return n}function C(t){for(var e=1;e<arguments.length;e++){var n=null!=arguments[e]?arguments[e]:{};e%2?S(Object(n),!0).forEach((function(e){P(t,e,n[e])})):Object.getOwnPropertyDescriptors?Object.defineProperties(t,Object.getOwnPropertyDescriptors(n)):S(Object(n)).forEach((function(e){Object.defineProperty(t,e,Object.getOwnPropertyDescriptor(n,e))}))}return t}function P(t,e,n){return e in t?Object.defineProperty(t,e,{value:n,enumerable:!0,configurable:!0,writable:!0}):t[e]=n,t}let E={};if(g.a.isLocalStorageAccessSafe())try{E=JSON.parse(localStorage.getItem("gl-keyboard-shortcuts-customizations")||"{}")}catch(t){}const x=E,q="globalShortcuts.togglePerformanceBar",T=[{groupId:"globalShortcuts",name:Object(_.d)("KeyboardShortcuts|Global Shortcuts"),keybindings:[{description:Object(_.d)("KeyboardShortcuts|Toggle the Performance Bar"),command:q,defaultKeys:["p b"]}]}].map((function(t){return C(C({},t),{},{keybindings:t.keybindings.map((function(t){return C(C({},t),{},{customKeys:x[t.command]})}))})})),D=o()(T.map((function(t){return t.keybindings}))).reduce((function(t,e){return t[e.command]=e.customKeys||e.defaultKeys,t}),{}),M=function(t){return p()?[]:D[t]},K=u.a.prototype.stopCallback;function B(){return new d.default({el:document.querySelector(".js-toggle-shortcuts"),render:t=>t(v)})}u.a.prototype.stopCallback=function(t,e,n){return-1===["ctrl+shift+p","command+shift+p"].indexOf(n)&&K.call(this,t,e,n)};const I="local-mousetrap-instance";function L(t){const e=t.closest(".md-area").find(".js-md"),n=new Map;return e.each((function(){const t=s()(this),e=t.data("md-shortcuts");(null==e?void 0:e.length)&&n.set(t,e)})),n}class H{constructor(){this.onToggleHelp=this.onToggleHelp.bind(this),this.enabledHelp=[],u.a.bind("?",this.onToggleHelp),u.a.bind("s",H.focusSearch),u.a.bind("/",H.focusSearch),u.a.bind("f",this.focusFilter.bind(this)),u.a.bind(M(q),H.onTogglePerfBar);const t=document.body.dataset.findFile;u.a.bind("shift+t",(function(){return Object(O.a)(".shortcuts-todos")})),u.a.bind("shift+a",(function(){return Object(O.a)(".dashboard-shortcuts-activity")})),u.a.bind("shift+i",(function(){return Object(O.a)(".dashboard-shortcuts-issues")})),u.a.bind("shift+m",(function(){return Object(O.a)(".dashboard-shortcuts-merge_requests")})),u.a.bind("shift+p",(function(){return Object(O.a)(".dashboard-shortcuts-projects")})),u.a.bind("shift+g",(function(){return Object(O.a)(".dashboard-shortcuts-groups")})),u.a.bind("shift+l",(function(){return Object(O.a)(".dashboard-shortcuts-milestones")})),u.a.bind("shift+s",(function(){return Object(O.a)(".dashboard-shortcuts-snippets")})),u.a.bind(["ctrl+shift+p","command+shift+p"],H.toggleMarkdownPreview),null!=t&&u.a.bind("t",(function(){Object(j.B)(t)})),s()(document).on("click.more_help",".js-more-help-button",(function(t){s()(this).remove(),t.preventDefault()})),s()(".js-shortcuts-modal-trigger").off("click").on("click",this.onToggleHelp),p()&&h()}onToggleHelp(t){t.preventDefault&&t.preventDefault(),H.toggleHelp(this.enabledHelp)}static onTogglePerfBar(t){t.preventDefault();Object(w.I)(c.a.get("perf_bar_enabled"))?c.a.set("perf_bar_enabled","false",{expires:365,path:"/"}):c.a.set("perf_bar_enabled","true",{expires:365,path:"/"}),Object(j.s)()}static toggleMarkdownPreview(t){const e=s()(t.target),n=e.closest("form");e.hasClass("js-note-text")&&s()(".js-md-preview-button",n).focus(),s()(document).triggerHandler("markdown-preview:toggle",[t])}static toggleHelp(t){const e=s()("#modal-shortcuts");return e.length?(e.modal("toggle"),null):k.a.get(gon.shortcuts_path,{responseType:"text"}).then((function(e){let{data:n}=e;if(s.a.globalEval(n,{nonce:Object(w.k)()}),t&&t.length>0){const e=[];for(let n=0,r=t.length;n<r;n+=1)e.push(s()(t[n]).show());return e}return s()(".js-more-help-button").remove()})).then(B)}focusFilter(t){this.filterInput||(this.filterInput=s()("input[type=search]",".nav-controls")),this.filterInput.focus(),t.preventDefault()}static focusSearch(t){s()("#search").focus(),t.preventDefault&&t.preventDefault()}static initMarkdownEditorShortcuts(t,e){const n=L(t),r=new u.a(t[0]);t.data(I,r),n.forEach((function(t,n){r.bind(t,(function(t){t.preventDefault(),e(n)}))}));const a=o()([...n.values()]),s=u.a.prototype.stopCallback;r.stopCallback=function(t,e,n){return!a.includes(n)&&s.call(this,t,e,n)}}static removeMarkdownEditorShortcuts(t){const e=t.data(I);e&&L(t).forEach((function(t){e.unbind(t)}))}}},yQ8t:function(t,e,n){"use strict";n.d(e,"a",(function(){return o}));var r=n("3twG");function o(t){const e=document.querySelector(t),n=e&&e.getAttribute("href");n&&Object(r.B)(n)}}}]);
//# sourceMappingURL=commons-pages.groups.boards-pages.groups.details-pages.groups.show-pages.projects-pages.projects.act-d59c63d5.791db178.chunk.js.map