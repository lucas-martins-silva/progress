/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0503RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0503rp MAB}
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

{abp/ab0503.i}  

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

    ASSIGN l-afericoes      =    tt-param.l-afericoes  
           l-transf         =    tt-param.l-transf     
           l-leitura        =    tt-param.l-leitura    
           l-Insere         =    tt-param.l-Insere     
           d-data-ini       =    tt-param.d-data-ini   
           d-data-fim       =    tt-param.d-data-fim   
           c-hora-ini       =    tt-param.c-hora-ini   
           c-hora-fim       =    tt-param.c-hora-fim   
           c-posto-ini      =    tt-param.c-posto-ini   
           c-posto-fim      =    tt-param.c-posto-fim  
           i-docto-ini      =    tt-param.i-docto-ini   
           i-docoto-fim     =    tt-param.i-docto-fim.  






             

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

{utp/ut-liter.i Listagem_do_Apontamento_de_Controle_de_Bombas * L}
assign c-programa     = "ab0503"
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
        {abp/ab0503.i2}
     END.

    WHEN 2 THEN DO:
        RUN pi-data-hora.
      {abp/ab0503.i3} 

     END.
      WHEN 3 THEN DO:
        RUN pi-posto.
       {abp/ab0503.i4} 

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
     form l-afericoes               colon 33
          l-transf                  colon 33
          l-leitura                 colon 33
          l-Insere                  colon 33 
     with stream-io   overlay side-labels row 014 frame f-imp-par.
     /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par:HANDLE).
     

   
     {utp/ut-liter.i Aferi‡äes  * L}
     assign   l-afericoes:label in frame f-imp-par = return-value.
     {utp/ut-liter.i Transferˆncias  * L}
     assign   l-transf:label in frame f-imp-par = return-value.
     {utp/ut-liter.i Leituras_de_Bombas * L}
      assign   l-leitura:label in frame f-imp-par = return-value.
     {utp/ut-liter.i Insere_Quebra_de_P gina  * L}
      assign   l-Insere:label in frame f-imp-par = return-value.

    
     {utp/ut-liter.i Sim/NÆo}
     assign  l-Insere:FORMAT in frame f-imp-par = return-value
             l-afericoes:FORMAT in frame f-imp-par = return-value 
             l-transf:FORMAT in frame f-imp-par = return-value   
             l-leitura:FORMAT in frame f-imp-par = return-value. 
               
     

     disp  l-afericoes
           l-transf   
           l-leitura  
           l-Insere   
           with frame f-imp-par.

     {utp/ut-liter.i SELE€ÇO * C}
     PUT  unformatted skip(1) return-value format "x(30)" AT 26 skip.
     disp 
      i-docto-ini       colon 33  "|< >|"  at 57 i-docto-fim   no-label
      d-data-fim        colon 33  "|< >|"  at 57 d-data-ini    no-label
      c-hora-ini        colon 33  "|< >|"  at 57 c-hora-fim    no-label
      c-posto-ini       colon 33  "|< >|"  at 57 c-posto-fim   no-label
      with stream-io side-labels overlay row 030 frame f-imp-sel.




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

