ativo = null;
cellAtivo = null;
timeId = null;
document.onclick = new Function("show()");

function addOption(obj,arr)
{
	var obj = document.getElementById(obj);
	var boxLength = obj.length;
	for(i=0; i<arr.length; i++)
	{
		newoption = new Option(arr[i][0], arr[i][1], false, false);
		obj.options[boxLength] = newoption;
		boxLength++;
	}
}

function show(cell,obj)
{
	obj = document.getElementById(obj);
	if(ativo!=null) { ativo.style.visibility = "hidden"; ativo=null;  cellAtivo.style.backgroundColor=''; }
	if(cell)
	{
		cell.style.backgroundColor='#F6F6F6';
		cellAtivo = cell;
	}
	if(timeId!=null){ clearTimeout(timeId); }
	if(obj)
	{
		obj.style.visibility = "visible";
		ativo = obj;
	}
}


function timerHidePop()
{
	if(ativo!=null)
	{
		timeId = setTimeout("ativo.style.visibility = 'hidden'; timeId=null; cellAtivo.style.backgroundColor=''; ativo=null;",3000);
	}
	else { 
	if(ativo==null){ cellAtivo.style.backgroundColor=''; }
	}
}

function escreveMenu(stringFinal){
 if ( document.all )
        {
                menu.innerHTML = stringFinal;
                menu.style.visibility = 'visible';
		        }
        else if ( !document.all && document.getElementById )
        {
                document.getElementById( "menu" ).innerHTML = stringFinal;
                document.getElementById( "menu" ).style.visibility = 'visible' ;
		        }
        else
        {
                menu.innerHTML = stringFinal;
                menu.style.visibility = 'visible' ;
		        }
}

function escreveColab(stringFinal){
 if ( document.all )
        {
                colab.innerHTML = stringFinal;
                colab.style.visibility = 'visible';
		        }
        else if ( !document.all && document.getElementById )
        {
                document.getElementById( "colab" ).innerHTML = stringFinal;
                document.getElementById( "colab" ).style.visibility = 'visible' ;
		        }
        else
        {
                colab.innerHTML = stringFinal;
                colab.style.visibility = 'visible' ;
		        }
}

desenvolvimento = new Array(
	Array('Banco de Dados','#','bd'),
	Array('Componentes','http://www.imasters.com.br/secao.php?cs=13',''),
	Array('JDeveloper','http://www.imasters.com.br/secao.php?codSecao=20403',''),
	Array('Linguagens','#','linguagens'),
	Array('Macromedia','#','macromedia'),
	Array('Mobile','http://www.imasters.com.br/secao.php?codSecao=51',''),
	Array('Plataforma .Net','#','dotnet'),
	Array('Software Livre','http://www.imasters.com.br/secao.php?cs=41',''),
	Array('UML','http://www.imasters.com.br/secao.php?codSecao=36',''),
	Array('Visual Fox Pro','http://www.imasters.com.br/secao.php?cs=58',''),
	Array('Zope','http://www.imasters.com.br/secao.php?codSecao=48','')
	);

design = new Array(
	Array('Criação 3D','#','3d'),
	Array('CSS/Estilos','http://www.imasters.com.br/secao.php?cs=32',''),
	Array('Desenho vetorial','http://www.imasters.com.br/secao.php?codSecao=20401',''),
	Array('Fireworks','http://www.imasters.com.br/secao.php?cs=9',''),
	Array('Flash','http://www.imasters.com.br/secao.php?cs=12',''),
	Array('Photoshop','http://www.imasters.com.br/secao.php?cs=5',''),
	Array('Suite Corel','http://www.imasters.com.br/secao.php?cs=45',''),
	Array('Teoria','http://www.imasters.com.br/secao.php?cs=15','')
	);

tecnologia = new Array(
	Array('Linux','http://www.imasters.com.br/secao.php?cs=21',''),
	Array('Redes','#','redes'),
	Array('Servidores Windows','http://www.imasters.com.br/secao.php?cs=69',''),
	Array('Segurança','http://www.imasters.com.br/secao.php?cs=23',''),
	Array('Tecnologia Geral','http://www.imasters.com.br/secao.php?cs=11',''),
	Array('Web Services','http://www.imasters.com.br/secao.php?cs=49','')
	);
	
gerencia = new Array(
	Array('Business Intelligence','http://www.imasters.com.br/secao.php?cs=57',''),
	Array('E-Commerce','http://www.imasters.com.br/secao.php?cs=20',''),
	Array('Eventos','http://www.imasters.com.br/secao.php?cs=6',''),
	Array('Gerenciando','http://www.imasters.com.br/secao.php?cs=3',''),
	Array('Mercado','http://www.imasters.com.br/secao.php?cs=63',''),
	Array('Web Marketing','http://www.imasters.com.br/secao.php?codSecao=20404','')
	);
	  
servicos = new Array(
	Array('Agenda de Eventos','http://www.imasters.com.br/agenda',''),
	Array('CD-ROMs iMasters','http://loja.imasters.com.br/busca_produtos.php?area=1&let_im_lv=39ddfaa5d99992639dc0cb9b755dde3d',''),
	Array('Códigos Livres','http://www.codigolivre.com.br',''),
	Array('Contratos p/ download','http://www.imasters.com.br/contratos',''),
	Array('CSS Interativo','http://www.imasters.com.br/cssinterativo',''),
	Array('Cursos Online','http://www.imasters.com.br/cursos',''),
	Array('Dicas iMasters','http://www.imasters.com.br/dicas',''),
	Array('E-mail iMasters','http://www.imasters.com.br/email',''),
	Array('Entrevistas','http://www.imasters.com.br/entrevistas',''),
	Array('Downloads','http://www.imasters.com.br/downloads',''),
	Array('FAQs','http://www.imasters.com.br/faq',''),
	Array('Fórum iMasters','http://forum.imasters.com.br',''),
	Array('Hospedagem','http://adserver.imasters.com.br/adclick.php?bannerid=252&zoneid=1&source=&dest=http://www.hostmidia.com.br',''),
	Array('iMasters InterCon','http://www.imasters.com.br/intercon2005',''),
	Array('Show banners','http://www.imasters.com.br/banners/01.php',''),
	Array('Vantagens','http://www.imasters.com.br/descontos','')
	);
	
interacao = new Array(
	Array('Anuncie no iMasters','http://www.imasters.com.br/anuncio',''),
	Array('Fale conosco','http://www.imasters.com.br/faleconosco','')
	)
	
titulo = new Array(desenvolvimento,design,tecnologia,gerencia,servicos,interacao);
titulonome = new Array('Desenvolvimento','Design','Tecnologia','Gerencia','Serviços','Interação');

var stringFinalMenu = '';

for(j=0; titulo[j]; j++)
{
	
	stringFinalMenu = stringFinalMenu+"<table width=\"132\" height=\"23\" border=\"0\" cellpadding=\"2\" cellspacing=\"0\"><tr><td width=\"4\" height=\"8\" bgcolor=\"#027E82\"></td><td rowspan=\"3\" bgcolor=\"#027E82\" class=\"arial cFFFFFF size11\"> &nbsp;&nbsp;<strong>"+titulonome[j]+"</strong></td></tr><tr><td width=\"4\" height=\"7\" bgcolor=\"#FF7A16\"></td></tr><tr><td width=\"4\" height=\"8\" bgcolor=\"#027E82\"></td></tr></table>"
	stringFinalMenu = stringFinalMenu+"<table width=\"132\" border=\"0\" cellpadding=\"2\" cellspacing=\"0\" class=\"arial size11 c333333\">";
	for(y=0; titulo[j][y]; y++)
	{
		
		if(y!=0){ estilo  = "class=\"bordaTop bcFFFFFF\"";} else{ estilo = "";}
		if(titulo[j][y][2]){ strmouseover = "show(this,'"+titulo[j][y][2]+"')"; seta = " <a href=\""+titulo[j][y][1]+"\" class=\"c333333 nlink\"><img src=\"http://www.imasters.com.br/img/outros/seta_menu.gif\" width=\"4\" height=\"6\" border=\"0\"></a>"; } else { strmouseover = "show(this);"; seta = "";}
		stringFinalMenu = stringFinalMenu+"<tr><td height=\"24\" colspan=\"2\" onMouseOver=\""+strmouseover+";\" onMouseOut=\"timerHidePop()\" "+estilo+"><img src=\"/img/pixels/pixel_transparente.gif\" width=\"1\" height=\"24\" align=\"absmiddle\">&nbsp;&nbsp;<a href=\""+titulo[j][y][1]+"\" class=\"c333333 nlink\">"+titulo[j][y][0]+"</a>"+seta+"</td></tr>";
	}
	
	stringFinalMenu = stringFinalMenu+"</table>";
}

var stringFinalColab = '';

stringFinalColab = '<br />';

for(z=0; arrColab[z]; z++)
{

stringFinalColab = stringFinalColab+"<table width=\"126\" height=\"34\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" class=\"arial size10\"><tr><td height=\"18\" bgcolor=\"#EAF9F9\" align=\"left\">&nbsp;<a href=\"http://www.imasters.com.br/artigo.php?cc="+arrColab[z][0]+"\" class=\"c545353 decNone\" >"+arrColab[z][2]+"</a></td><td width=\"29\" height=\"34\" rowspan=\"2\"><a href=\"http://www.imasters.com.br/artigo.php?cc="+arrColab[z][0]+"\" class=\"c053669 decNone\" ><img src=\"http://www.imasters.com.br/conteudo/"+arrColab[z][1]+"/_dados/capa.gif\" width=\"29\" border=\"0\" height=\"34\" /></a></td></tr><tr><td height=\"16\" bgcolor=\"#C7EAEA\" align=\"left\">&nbsp;<a href=\"http://www.imasters.com.br/artigo.php?cc="+arrColab[z][0]+"\" class=\"c053669 decNone\" >"+arrColab[z][3]+"</a></td></tr></table><br />";

}
