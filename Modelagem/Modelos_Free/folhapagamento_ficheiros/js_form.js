// 
function RadioFieldValue(f)
{
  var i;
  for (i = 0; i < f.length; i++)
    if(f[i].checked)
      return r[i].value;
}
// Eventos e funções para validação de formulários

function IntFieldKeyPress(e)
{
	if (document.all) // Internet Explorer
		var tecla = e.keyCode;
	else if(document.layers) // Netscape
		var tecla = e.which;
	if ((tecla > 47 && tecla < 58)  || tecla == 8 || tecla == 13) // numeros de 0 a 9 e backspace
		return true;
	else
	{
		event.keyCode = 0;
	}
}
function NumFieldKeyPress(e)
{
	if (document.all) // Internet Explorer
		var tecla = event.keyCode;
	else if(document.layers) // Netscape
		var tecla = e.which;
	if ((tecla > 47 && tecla < 58) || tecla == 44 || tecla == 46 || tecla == 8 || tecla == 13) // numeros de 0 a 9, virgula, ponto e backspace
		return true;
	else
	{
		event.keyCode = 0;
	}
}
function DateFieldKeyPress(e)
{
	if (document.all) // Internet Explorer
		var tecla = event.keyCode;
	else if(document.layers) // Netscape
		var tecla = e.which;
	if ((tecla > 47 && tecla < 58) || tecla == 47 || tecla == 8 || tecla == 13) // numeros de 0 a 9, virgula, ponto e backspace
		return true;
	else
	{
		event.keyCode = 0;
	}
}
function CEPFieldKeyPress(e)
{
	if (document.all) // Internet Explorer
		var tecla = event.keyCode;
	else if(document.layers) // Netscape
		var tecla = e.which;
	if ((tecla > 47 && tecla < 58) || tecla == 45 || tecla == 8 || tecla == 13) // numeros de 0 a 9 e hifen
		return true;
	else
	{
		event.keyCode = 0;
	}
}

function FieldCheck(field, desc)
{
  if (field.value == "")
  {
    alert(desc+" em branco.");
    field.focus();
    field.select();
    return false;
  }
  else
  {
	return true;
  }
}
function SelectFieldCheck(field, desc, invalidIndex) // -1 para nenhum item e 0 para o primeiro item
{
  if (field.selectedIndex == invalidIndex)
  {
    alert("Selecione um valor válido para "+desc+".");
    field.focus();
    return false;
  }
  else
  {
	return true;
  }
}
function FieldLenCheck(field, desc, tmin, tmax)
{
  if (!FieldCheck(field, desc))
  {
	return false;
  }
  else
  {
	if (field.value.length < tmin)
	{
      alert(desc+" deve ter ao menos "+tmin+" caracteres.");
      field.focus();
      field.select();
      return false;
	}
	else
	{
	  if ((tmax > tmin) && (field.value.length > tmax))
	  {
        alert(desc+" deve ter até "+tmax+" caracteres.");
        field.focus();
        field.select();
        return false;
	  }
	  else
	  {
		return true;
	  }
	}
  }
}
function NumFieldCheck(field, desc, tmin, tmax)
{
// Primeiro verifica se o campo está em branco
  if (!FieldCheck(field, desc))
  {
	return false;
  }
  else
  {
    if (!isNumber(field.value))
    {
      alert(desc+" inválido.");
      field.focus();
      field.select();
      return false;
	}
	else
	{
	  if (parseFloat(field.value) < tmin)
	  {
        alert(desc+" inválido.");
        field.focus();
        field.select();
        return false;
	  }
	  else
	  {
		if (tmax > tmin && parseFloat(field.value) > tmin)
	    {
          alert(desc+" inválido.");
          field.focus();
          field.select();
          return false;
		}
		else
		{
		  return true;
		}
	  }
	}
  }
}
function DateFieldCheck(field, desc)
{
  if (!FieldCheck(field, desc))
  {
	return false;
  }
  else
  {
	var tmp = field.value.split("/");
	if (tmp.length != 3 || tmp[0].length != 2 || tmp[1].length != 2 || tmp[2].length != 4 || !isNumber(tmp[0]) || !isNumber(tmp[1]) || !isNumber(tmp[2]))
	{
	  alert(desc+" não é uma data válida.");
	  field.focus();
	  field.select();
	  return false;
	}
	else
	{
	  return true;
	}
  }
}
function CEPFieldCheck(field, desc)
{
// Primeiro verifica se o campo está em branco
  if (!FieldCheck(field, desc))
  {
	return false;
  }
  else
  {
// Agora verifica o tamanho do campo e a posição do hifen (se tiver)
    if (field.value.length < 8 || field.value.length > 9 || (field.value.indexOf("-") > -1 && field.value.indexOf("-") != 5) || field.value.split("-").length > 2)
	{
      alert("CEP inválido.");

      field.focus();
      field.select();
      return false;
	}
	else
	{
	  return true;
	}
  }
}
function CPFCNPJFieldCheck(field, desc)
{
// Primeiro verifica se o campo está em branco
  if(!FieldCheck(field, desc))
  {
	return false;
  }
  else
  {
// Se o tamanho do campo for 11, então o considera CPF
	if(field.value.length == 11) // CPF
	{
	  if(ValidaCPF(field.value))
	  {
		return true;
	  }
	  else
	  {
        alert("CPF inválido.");
        field.focus();
        field.select();
        return false;
	  }
	}
	else
	{
// Se o tamanho do campo for 14, então o considera CNPJ
	  if(field.value.length == 14) // CNPJ
	  {
		if(ValidaCNPJ(field.value))
		{
		  return true;
		}
		else
	    {
          alert("CNPJ inválido.");
          field.focus();
          field.select();
          return false;
		}
	  }
	  else
	  {
// Se o tamanho do campo for diferente de 11 e 14, então avisa o usuário
        alert("O CPF deve conter 11 caracteres e o CNPJ deve conter 14 caracteres.");
        field.focus();
        field.select();
        return false;
	  }
	}
  }
}

function EmailFieldCheck(field, desc)
{
// Primeiro verifica se o campo está em branco
  if (!FieldCheck(field, desc))
  {
    return false;
  }
  else
  {
    var tmp = field.value.split("@");
// Agora verifica a forma nn_n@s_s
	if ((tmp.length != 2) || (tmp[0].length < 2)) //(tmp[1].indexOf(".") <= 0)
	{
      alert(desc+" inválido.");
      field.focus();
      field.select();
      return false;
	}
	else
	{
	  tmp = tmp[1].split(".");
// Agora verifica a forma s= hh_h.ttt ou hh_h.ttt.pp
	  if ((tmp.length < 2 || tmp.length > 3) || tmp[0].length < 2 || tmp[1].length < 2 || (tmp.length == 3 && tmp[2].length < 2))
	  {
        alert(desc+" inválido.");
        field.focus();
        field.select();
        return false;
	  }
// Agora verifica a presença de nomes falsos no campo
	  else if (tmp[0] == "rotmeio" || tmp[0] == "teste" || tmp[0] == "abc" || tmp[0] == "xyz" || tmp[0] == "hotmeil" || tmp[0] == "iarru" || tmp[0] == "xxx" || tmp[0] == "aaa")
	  {
        alert(desc+" aparentemente inválido.");
        field.focus();
        field.select();
        return false;
	  }
	  else
	  {
	    return true;
	  }
	}
  }
}
