// ==UserScript==
// @name           NZB Ids
// @namespace      http://nzb.tomlea.co.uk/nzbids
// @include        http://v3.newzbin.com/search/query/
// ==/UserScript==

var e = document.getElementsByTagName("a");
for(var i=0;i<e.length;i++){
    var el = e[i];
    if(el.href.match(new RegExp('/browse/post/([0-9][0-9]*)/')) && el.parentNode.tagName.match(/STRONG/))
    {
        var span = document.createElement("span");
        span.innerHTML = el.href.replace(new RegExp('.*/browse/post/([0-9][0-9]*)/'), ' --- <a href="http://mediaoca/hellanzb/enqueue?enqueue[newzbin_id]=$1">!Mediaoca!</a> --- ');
        el.parentNode.appendChild(span);
    }
}
