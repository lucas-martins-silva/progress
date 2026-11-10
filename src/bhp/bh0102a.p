/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BH0102A 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i Bh0102a MBH}
&ENDIF

/**************************************************************************
**
**  Programa: BH0102A.P
**
**  Data....: JULHO DE 1997
**
**  Autor...: DATASUL DESENVOLVIMENTO DE SISTEMAS S.A.
**
**  Objetivo: Retornar dados para o banco de movimentos (Contas a Pagar)
**
******************************************************************************/

/**** Miniflexibilizacao ****/
{cdp/cdcfgfin.i}

/**** Definiá∆o das Temp-Tables ****/

/**** W-PER ***/
{bhp/bh0102.i2}

def buffer b-mov-ap for hisadm.mov-ap.

def input  param da-corte   as   date format "99/99/9999" no-undo.
def input  param i-empresa  like empresa.ep-codigo        no-undo.
def output param i-registro as   int format ">>>,>>9"     no-undo.

def var i-cont  as int    no-undo.
def var h-acomp as handle no-undo.

for each w-per exclusive-lock:
    delete w-per.
end.

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Importando...").

assign i-registro = 0.
for each b-mov-ap use-index data
    where b-mov-ap.ep-codigo = i-empresa
    and   b-mov-ap.dt-transacao >= da-corte no-lock:

    {cdp/cd9910.i i-cont}

    do for hisadm.tit-ap:
       find first hisadm.tit-ap use-index codigo
           where hisadm.tit-ap.ep-codigo   = b-mov-ap.ep-codigo
           and   hisadm.tit-ap.cod-fornec  = b-mov-ap.cod-fornec
           and   hisadm.tit-ap.cod-estabel = b-mov-ap.cod-estabel
           and   hisadm.tit-ap.cod-esp     = b-mov-ap.cod-esp
           and   hisadm.tit-ap.serie       = b-mov-ap.serie
           and   hisadm.tit-ap.nr-docto    = b-mov-ap.nr-docto
           and   hisadm.tit-ap.parcela     = b-mov-ap.parcela
           no-lock no-error.


       if  avail hisadm.tit-ap then do:
           &IF DEFINED(BF_FIN_RAC) &THEN
               if  hisadm.tit-ap.origem = 5  then
                   next.
           &ENDIF 
       
           run bhp/bh0102aa.p (input hisadm.tit-ap.ep-codigo,
                               input hisadm.tit-ap.cod-estabel,
                               input hisadm.tit-ap.cod-fornec,
                               input hisadm.tit-ap.cod-esp,
                               input hisadm.tit-ap.serie,
                               input hisadm.tit-ap.nr-docto,
                               input hisadm.tit-ap.parcela,
                               input-output i-registro,
                               input-output table w-per).

           if  RETURN-VALUE = "NOK":U THEN
               next.
       end.
       else do:

          /*---- Eliminado Pagamentos Extra-Fornecedor ----*/

          if  b-mov-ap.transacao <> 3
          and b-mov-ap.transacao <> 4 then
              next.

          do  for hisadm.mov-ap:
              find first hisadm.mov-ap
                   where rowid(hisadm.mov-ap) = rowid(b-mov-ap)
                   exclusive-lock no-error.

              do  for hisadm.che-emit:
                  find first hisadm.che-emit  use-index codigo
                       where hisadm.che-emit.ep-codigo   = hisadm.mov-ap.ep-codigo
                       and   hisadm.che-emit.portador    = hisadm.mov-ap.portador
                       and   hisadm.che-emit.nr-cheque   = hisadm.mov-ap.nr-cheque
                       and   hisadm.che-emit.cod-fornec  = hisadm.mov-ap.cod-fornec
                       and   hisadm.che-emit.cod-estabel = hisadm.mov-ap.cod-estabel
                       and   hisadm.che-emit.cod-esp     = hisadm.mov-ap.cod-esp
                       and   hisadm.che-emit.serie       = hisadm.mov-ap.serie
                       and   hisadm.che-emit.nr-docto    = hisadm.mov-ap.nr-docto
                       and   hisadm.che-emit.parcela     = hisadm.mov-ap.parcela
                       and   hisadm.che-emit.transacao   = hisadm.mov-ap.transacao
                       and   hisadm.che-emit.dt-emissao  = hisadm.mov-ap.dt-transacao
                       exclusive-lock no-error.
                  if  avail hisadm.che-emit then do:
                      {bhp/bh9801.i &area=adm &arqmov=che-emit} 
                      delete hisadm.che-emit.
                      assign i-registro = i-registro + 1.
                      release hisadm.che-emit.
                  end.
              end.

              if  hisadm.mov-ap.transacao = 1 
              or  hisadm.mov-ap.transacao = 2 then do:
                
                  /**** BUSCA O PORTADOR DO MOVIMENTO ****/
                  find first portador 
                       where portador.ep-codigo    = hisadm.mov-ap.ep-codigo
                       and   portador.cod-portador = hisadm.mov-ap.portador
                       and   portador.modalidade   = hisadm.mov-ap.modalidade 
                       no-lock no-error.
                
                  if  avail portador  then do:
                
                      /**** BUSCA O CHEQUE RELACIONADO AO MOVIMENTO ****/
                      find first hisadm.cheque
                           where hisadm.cheque.cod-banco     = portador.cod-banco
                           and   hisadm.cheque.agencia       = portador.agencia
                           and   hisadm.cheque.conta-corren  = portador.conta-corren 
                           and   hisadm.cheque.nr-cheque     = hisadm.mov-ap.nr-cheque
                           and   hisadm.cheque.origem-cheque = 5 /* AP */
                           exclusive-lock no-error.
                      if  avail hisadm.cheque then do:
                          run pi-elimina-his-cheque.

                          {bhp/bh9801.i &area=adm &arqmov=cheque}
                          delete hisadm.cheque.
                          release hisadm.cheque.
                          assign i-registro = i-registro + 1.
                      end.
                
                  end.
              end.

              find first hisadm.cheque
                   where hisadm.cheque.cod-banco    = hisadm.mov-ap.banco
                   and   hisadm.cheque.agencia      = hisadm.mov-ap.agencia
                   and   hisadm.cheque.conta-corren = hisadm.mov-ap.cta-corrente
                   and   hisadm.cheque.nr-cheque    = hisadm.mov-ap.nr-cheque NO-LOCK no-error.
              
              /**** Os movimentos de PEF que zeram a provis∆o n∆o est∆o mais diponiveis ***/
              if  avail mov-ap then do:
                 {bhp/bh9801.i &area=adm &arqmov=mov-ap}
                 {bhp/bh0102.i AP hisadm.mov-ap.dt-transacao}
                 delete hisadm.mov-ap.
                 assign i-registro = i-registro + 1.
                 
                 /**** Atualizaá∆o da tabelas no banco de dados *****/
                 
                 release hisadm.mov-ap.
                 
              end.
          end.
       end.
   end.
end.

for each w-per:
    find first bh-periodos EXCLUSIVE-LOCK where
               bh-periodos.ep-codigo = w-per.i-emp and
               bh-periodos.modulos   = w-per.c-mod no-error.
    if  not avail bh-periodos then do:
        create bh-periodos.
        assign bh-periodos.ep-codigo = w-per.i-emp
               bh-periodos.modulos   = w-per.c-mod
               bh-periodos.area      = "A".
    end.
    assign bh-periodos.periodo = w-per.da-per - 1.
end.

if valid-handle(h-acomp) then
    run pi-finalizar in h-acomp.

/*--- fim BH0102A.P ---*/


/***** [ PROCEDURES INTERNAS ] ******/

PROCEDURE pi-elimina-his-cheque :
    &IF DEFINED(BF_FIN_BANCO_HIST_ADM) &THEN
        find first his-cheque
             where his-cheque.cod-banco    = hisadm.cheque.cod-banco
             and   his-cheque.agencia      = hisadm.cheque.agencia
             and   his-cheque.conta-corren = hisadm.cheque.conta-corren
             and   his-cheque.nr-cheque    = hisadm.cheque.nr-cheque
             exclusive-lock no-error.
        if  avail his-cheque then do:
            delete his-cheque.
            release his-cheque.
       end.
    &ENDIF
END PROCEDURE.

