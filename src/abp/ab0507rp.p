/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0507RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0507rp MAB}
&ENDIF


{include/i_fnctrad.i}
/********************************************************************************
**
**       PROGRAMA: gc0401rp.p
**
**       DATA....: Dezembro de 2002
**
**       AUTOR...: DATASUL S.A.
**
**       OBJETIVO: 
**       Versao..: 2.00.00.000
**
********************************************************************************/

/** Definicao das temp-tables para recebimento dos parametros **/

{abp/ab0507.i}  
{include/pi-edit.i}

/* Recebimento de parametros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* Include padroes para variaveis de relatorio */
{include/i-rpvar.i}

    if connected("dthrpyc") then do:
      def var v_han_fpapi003 as handle no-undo.
      run prghur/fpp/fpapi003.p persistent set v_han_fpapi003 (input tt-param.usuario,
                                                               input tt-param.v_num_tip_aces_usuar).
    end.

/* Include padrao para output de relatorios */
{include/i-rpout.i }
view frame f-cabec.
view frame f-rodape.

    ASSIGN l-ReservaAtend   =     tt-param.l-ReservaAtend 
           l-ReservaNAtend  =     tt-param.l-ReservaNAtend
           l-Insere        =     tt-param.l-Insere  
           i-reserva-ini    =     tt-param.i-reserva-ini  
           i-reserva-fim    =     tt-param.i-reserva-fim  
           d-data-ini       =     tt-param.d-data-ini     
           d-data-fim       =     tt-param.d-data-fim     
           c-hora-ini       =     tt-param.c-hora-ini     
           c-hora-fim       =     tt-param.c-hora-fim     
           c-rota-orig-ini  =     tt-param.c-rota-orig-ini
           c-rota-orig-fim  =     tt-param.c-rota-orig-fim
           c-rota-dest-ini  =     tt-param.c-rota-dest-ini
           c-rota-dest-fim  =     tt-param.c-rota-dest-fim
           i-cod-emp-ini    =     tt-param.i-cod-emp-ini  
           i-cod-emp-fim    =     tt-param.i-cod-emp-fim  
           c-cod-eqpto-ini  =     tt-param.c-cod-eqpto-ini
           c-cod-eqpto-fim  =     tt-param.c-cod-eqpto-fim
           c-empresa-matr-ini  =  tt-param.c-empresa-matr-ini
           c-empresa-matr-fim  =  tt-param.c-empresa-matr-fim
           c-estabel-matr-ini  =  tt-param.c-estabel-matr-ini
           c-estabel-matr-fim  =  tt-param.c-estabel-matr-fim
           c-cod-matr-ini   =     tt-param.c-cod-matr-ini 
           c-cod-matr-fim   =     tt-param.c-cod-matr-fim. 
             

/* Include com a definicao da frame de cabecalho e rodape */
{include/i-rpcab.i }    

/* Bloco principal do programa */


    find first param-global no-lock no-error.
    if  available param-global THEN DO:
        FIND FIRST empresa WHERE ep-codigo = empresa-prin NO-LOCK NO-ERROR.
        if  available empresa THEN
            ASSIGN c-empresa = empresa.razao-social.
    END.
find first tt-param.

{utp/ut-liter.i Apontamentos_de_Controle_de_Reservas * L}
assign c-programa     = "ab0507"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = return-value
       c-sistema      = "".

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo").


/*****Includes para Display dos Relat¢rios***/
  
 CASE tt-param.classifica:
     WHEN 1 THEN DO:
        RUN pi-documento.
        {abp/ab0507.i2}
     END.

    WHEN 2 THEN DO:
        RUN pi-data-hora.
       {abp/ab0507.i3} 

     END.
     WHEN 3 THEN DO:
        RUN pi-equipamento.
       {abp/ab0507.i4}
     END.
    
 END CASE.



         
/*Fechamento do output do relat¢rio*/

run pi-finalizar in h-acomp.
view frame f-cabec.
view frame f-rodape.
 
 
if  tt-param.parametro = YES then do:
    PAGE.

     PUT SKIP (1).
     {utp/ut-liter.i PAR¶METROS * C}
     PUT  unformatted skip(1) return-value format "x(30)" AT 23 skip.
     form 
     l-ReservaAtend       colon 33 label "Reservas Atendidas       " format "Sim/NÆo"
     l-ReservaNAtend      colon 33 label "Reservas NÆo Atendidas   " format "Sim/NÆo"
     l-Insere           colon 33 label "Insere Quebra de P gina"   
      with stream-io   overlay side-labels row 014 frame f-imp-par.
     /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par:HANDLE).
     

   
   {utp/ut-liter.i Reservas_Atendidas  * L}
   assign l-ReservaAtend:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Reservas_NÆo_Atendidas  * L}
   assign  l-ReservaNAtend:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Insere_Quebra_de_P gina  * L}
   assign   l-Insere:label in frame f-imp-par = return-value.
   

   disp 
     l-ReservaAtend   
     l-ReservaNAtend  
     l-Insere
     with frame f-imp-par.

   {utp/ut-liter.i SELE€ÇO * C}
   PUT  unformatted skip(1) return-value format "x(30)" AT 26 skip.
   disp 
      i-reserva-ini        colon 33  "|< >|"  at 57 i-reserva-fim      no-label
      d-data-ini           colon 33  "|< >|"  at 57 d-data-fim         no-label
      c-hora-ini           colon 33  "|< >|"  at 57 c-hora-fim         no-label
      c-rota-orig-ini      colon 33  "|< >|"  at 57 c-rota-orig-fim    no-label
      c-rota-dest-ini      colon 33  "|< >|"  at 57 c-rota-dest-fim    no-label
      i-cod-emp-ini        colon 33  "|< >|"  at 57 i-cod-emp-fim      no-label
      c-cod-eqpto-ini      colon 33  "|< >|"  at 57 c-cod-eqpto-fim    no-label
      c-empresa-matr-ini LABEL "Motorista" COLON 33 "-" c-estabel-matr-ini NO-LABEL "-" c-cod-matr-ini NO-LABEL "|< >|"  at 57 c-empresa-matr-fim NO-LABEL "-" c-estabel-matr-fim NO-LABEL "-" c-cod-matr-fim NO-LABEL
       WITH WIDTH 132 stream-io side-labels overlay row 030 frame f-imp-sel.
   /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
   RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-sel:HANDLE).
   

   {utp/ut-liter.i CLASSIFICA€ÇO * R}
   PUT  unformatted skip(1) return-value format "x(30)" AT 21 skip.
    disp  desc-classifica  AT 35 NO-LABEL 
          with stream-io side-labels overlay row 030 frame f-imp-cla.

   {utp/ut-liter.i IMPRESSÇO * C}
    PUT  unformatted skip(1) return-value format "x(30)" AT 25 skip.
   {utp/ut-liter.i Destino: * L}
   put unformatted skip "    " return-value format "x(10)" AT 23 v-cod-destino-impres " - " tt-param.arquivo format "x(40)".
   {utp/ut-liter.i Execu‡Æo: * L}
   put  unformatted skip "    " return-value format "x(12)" AT 22 if i-num-ped-exec-rpw = 0 then " On-Line" else " Batch".
   {utp/ut-liter.i Usu rio: * L}
   put  unformatted skip "    " return-value format "x(10)" AT 23 tt-param.usuario.

end.



{include/i-rpclo.i }

return "OK":U.

