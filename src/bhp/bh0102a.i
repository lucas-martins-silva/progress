/**********************************************************************************
***
***   BH0102A.i - Elimina‡Æo das tableas HIS-TIT
***
**********************************************************************************/

/*------------------ Elimina da tabela de locks -----------------*/
find first his-tit-ap
     where his-tit-ap.ep-codigo   = hisadm.tit-ap.ep-codigo
     and   his-tit-ap.cod-fornec  = hisadm.tit-ap.cod-fornec
     and   his-tit-ap.cod-estabel = hisadm.tit-ap.cod-estabel
     and   his-tit-ap.cod-esp     = hisadm.tit-ap.cod-esp
     and   his-tit-ap.serie       = hisadm.tit-ap.serie
     and   his-tit-ap.nr-docto    = hisadm.tit-ap.nr-docto
     and   his-tit-ap.parcela     = hisadm.tit-ap.parcela no-error.
if  avail his-tit-ap then
    delete his-tit-ap validate(true,"").
/*---------------------------------------------------------------*/

{bhp/bh0102.i AP hisadm.tit-ap.dt-transacao}

delete hisadm.tit-ap validate(true,"").

release tit-ap.
release his-tit-ap.

assign i-registro = i-registro + 1.


/*--- BH0102A.I ---*/
