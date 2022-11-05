var tmpStr="";
var popUpWin=0;
var PicWin=0;
var ns4 = document.layers;
var ns6 = document.getElementById && !document.all;
var ie4 = document.all;
function Point(x,y) {  this.x = x; this.y = y; }
mousePoint = new Point(-500,-500);

function getMouseLoc2(e)
{
  if(ns4 || ns6)  //NS
  {
    mousePoint.x = e.pageX;
    mousePoint.y = e.pageY;
  }
  else               //IE
  {
    mousePoint.x = event.x + document.body.scrollLeft;
    mousePoint.y = event.y + document.body.scrollTop;
  }
  return true;
}
if(ns4 || ns6)
{
  document.captureEvents(Event.MOUSEMOVE);
  document.onMouseMove = getMouseLoc2;
}
function getMouseLoc()
{
  if (ns4 || ns6)
    { return getMouseLoc2; }
  else
    { return getMouseLoc2(); }
}

var toolTipSpace = 8;
function toolTip(s, t, r)
{
  if (!s)
  {
	document.getElementById("toolTip").innerHTML = "";
    document.getElementById("toolTip").style.visibility = "hidden";
    return false;
  }
  else if(!t)
  {
/*	getMouseLoc();
	document.getElementById("toolTip").innerHTML = s;
    document.getElementById("toolTip").style.left = mousePoint.x + 0;
    document.getElementById("toolTip").style.top = mousePoint.y + 20;
    document.getElementById("toolTip").style.visibility = "visible";*/
    return true;  
  }
  else
  {
	document.getElementById("toolTip").innerHTML = s;
	if(!r)
	{
	  document.getElementById("toolTip").style.left = t.offsetLeft;
	  document.getElementById("toolTip").style.top = t.offsetTop + t.offsetHeight + toolTipSpace;
	}
	else
	{
	  document.getElementById("toolTip").style.left = t.offsetLeft + t.offsetWidth + toolTipSpace;
	  document.getElementById("toolTip").style.top = t.offsetTop;
	}
	document.getElementById("toolTip").style.visibility = "visible";
    return true;
  }
}
function trim(vStr)
{
	var strAux = new String(vStr);
	return strAux.replace(/(^\s*)|(\s*$)/g, '');
} 

function isNumber(numero, bDecimal)
{ 
	for (i=0; i < numero.length; i++)
	{ 
		var car = numero.charAt(i);
		if (bDecimal) 
		{
			if(car != "." && car != "," && car != "-")
			{  
				if (isNaN(parseInt(car))) 
					return false; 
			}
		}
		else
		{ 
			if(car != "-")
				if (isNaN(parseInt(car))) return false; 

		} 
	}
	return true;
} 

function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed)
	{
	  popUpWin.close();
	}
  }
  if(left = -1)
  {
	left = (screen.width/2)-width/2;
  }
  if(top = -1)
  {
	top = (screen.height/2)-height/2;
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}
function PictureWin(src,alt)
{
// Se já tiver alguma figura aberta, fechá-la
  if(PicWin)
  {
    if(!PicWin.closed)
	{
	  PicWin.close();
	}
  }
  var width = 780, height = 500;
  var left = (screen.width/2)-width/2;
  var top = (screen.height/2)-height/2;
  var styleStr = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=800,height=500,left='+left+', top='+top+',screenX='+left+',screenY='+top;
  PicWin = open("", 'PicWin', styleStr);
  var head = "<html><head><title>Figura ampliada</title><link rel='STYLESHEET' type='text/css' href='ideia.css'></head>";
  var body = "<body><img src='"+src+"' alt='"+alt+"'><p>"+alt+"</p>";
  body = body + "<center><input type=button class=button value='Fechar' onClick='self.close();'></center></body></html>";
  PicWin.document.write(head + body);
}
function messageWindow(title, msg)
{
  if(msgWin)
  {
    if(!msgWin.closed)
	{
	  msgWin.close();
	}
  }
  var width="300", height="200";
  var left = (screen.width/2) - width/2;
  var top = (screen.height/2) - height/2;
  var styleStr = 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top;
  var msgWin = window.open("msgbox.asp?p1="+title+"&p2="+msg,"msgWin", styleStr);
}
/* Um pouco de estética */
function MenuItemMouseOver(t)
{
  t.parentNode.className = 'menuHover';
  toolTip();
}
function MenuItemMouseOverTip(t, s)
{
  t.parentNode.className = 'menuHover';
  toolTip(s);
}
function MenuItemMouseOut(t)
{
  t.parentNode.className = 'menu';
  t.className = 'menu';
  toolTip();
}
function MenuItemMouseDown(t)
{
  t.parentNode.className = 'menuFocus';
  t.className = 'menuFocus';
  toolTip();
}
function MenuItemMouseUp(t)
{
  t.parentNode.className = 'menuHover';
  t.className = 'menu';
  toolTip();
}
function FieldFocus(t)
{
  t.className = 'focus';
//  if(t.value.toLowerCase.indexOf("digite") > -1)
//	t.value == "";
}
function FieldFocusTip(t, s, r)    
{
  FieldFocus(t);
  toolTip(s, t, r);
}
function FieldBlur(t)
{
  t.className = '';
  toolTip();
}
function ValidaCNPJ(cnpj)
{
	var mult1 = "543298765432";
	var mult2 = "654329876543";
	if(cnpj.length != 14)
		return false;
	var soma = 0;
	for(var x = 0; x <= 11; x++)
    {
		soma += parseInt(cnpj.substr(x, 1)) * parseInt(mult1.substr( x, 1));
	}
	var resto = soma % 11;
	var D1=0;
	if(!(resto == 0 || resto == 1))
    	D1 = 11 - resto;
	if(D1 != cnpj.substr(12, 1))
		return false;
	soma = 0;
	for(x = 0; x <= 11; x++)
	{
	    soma += parseInt(cnpj.substr(x, 1)) * parseInt(mult2.substr(x, 1));
	}
	soma += 2 * parseInt(D1);
	resto = soma % 11;
	var D2=0;
	if(!(resto == 0 || resto == 1))
	    	D2 = 11 - resto;
	if(D2 != parseInt(cnpj.substr(13, 1)))
		return false;
	else
		return true;
}function ValidaCNPJ(cnpj)
{
	var mult1 = "543298765432";
	var mult2 = "654329876543";
	if(cnpj.length != 14)
		return false;
	var soma = 0;
	for(var x = 0; x <= 11; x++)
    {
		soma += parseInt(cnpj.substr(x, 1)) * parseInt(mult1.substr( x, 1));
	}
	var resto = soma % 11;
	var D1=0;
	if(!(resto == 0 || resto == 1))
    	D1 = 11 - resto;
	if(D1 != cnpj.substr(12, 1))
		return false;
	soma = 0;
	for(x = 0; x <= 11; x++)
	{
	    soma += parseInt(cnpj.substr(x, 1)) * parseInt(mult2.substr(x, 1));
	}
	soma += 2 * parseInt(D1);
	resto = soma % 11;
	var D2=0;
	if(!(resto == 0 || resto == 1))
	    	D2 = 11 - resto;
	if(D2 != parseInt(cnpj.substr(13, 1)))
		return false;
	else
		return true;
}

function ValidaCPF(cpf)
{
	var mult = "98765432";
	if(cpf.length!= 11)
		return false;
	for ( var i=0 ; i<10 ; i++ )
	{
		var temp = "";
		for ( var j=0 ; j<11 ; j++ ) temp += String(i);
		if ( temp == cpf ) return false;
	}
	var soma = 10 * parseInt(cpf.substr(0, 1));
	for(var x = 1; x <= 8; x++)
    {
		soma += parseInt(cpf.substr(x, 1)) * parseInt(mult.substr(x - 1, 1));
	}
	var resto = soma % 11;
	var D1 = 0;
	if(!(resto == 0 || resto == 1))
    	D1 = 11 - resto;
	if(D1 != parseInt(cpf.substr(9, 1)))
		return false;
	soma = 11 * parseInt(cpf.substr(0, 1)) + 10 * parseInt(cpf.substr(1, 1));
	for(x = 2; x<=8; x++)
	{
	    soma += parseInt(cpf.substr(x, 1)) * parseInt(mult.substr(x - 2, 1));
	}
	soma += (2 * parseInt(D1));
	resto = soma % 11;
	var D2 = 0;
	if(!(resto == 0 || resto == 1))
		D2 = 11 - resto;
	if(D2 != parseInt(cpf.substr(10, 1)))
		return false;
	else
		return true;
}
 
function DeleteConfirm(h, s)
{
  var ok;
  if (!s)
    ok = confirm("Confirma a exclusão do registro?")
  else ok = confirm(s);
  if (ok)
    window.location.href = h;
}