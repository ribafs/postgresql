
ns4 = ( document .layers) ? true : false ;
ie4 = ( document .all) ? true : false;

function pop(url,nome,x,y,resizable,toolbar,status,menubar,scrollbars)
{
	
	window.open(url,nome,"resizable="+resizable+",toolbar="+toolbar+",status="+status+",menubar="+menubar+",scrollbars="+scrollbars+",width="+x+",height="+y);
}

function limpaInput(obj)
{
	if(obj.value==s && clicadoinput==""){ clicadoinput=obj.value; obj.value="";}
}