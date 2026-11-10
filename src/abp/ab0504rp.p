/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0504RP 2.00.00.003}  /*** 010003 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0504rp MAB}
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

{abp/ab0504.i}  

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

    ASSIGN c-estabelec-ini       = tt-param.c-estabelec-ini   
           c-estabelec-fim       = tt-param.c-estabelec-fim   
           c-eqpto-ini           = tt-param.c-eqpto-ini       
           c-eqpto-fim           = tt-param.c-eqpto-fim       
           c-grupo-fim           = tt-param.c-grupo-fim       
           c-grupo-ini           = tt-param.c-grupo-ini       
           c-modelo-fim          = tt-param.c-modelo-fim      
           c-modelo-ini          = tt-param.c-modelo-ini      
           c-tag-fim             = tt-param.c-tag-fim         
           c-tag-ini             = tt-param.c-tag-ini         
           c-empresa-ini         = tt-param.c-empresa-ini     
           c-empresa-fim         = tt-param.c-empresa-fim     
           c-estrut-mec-ini      = tt-param.c-estrut-mec-ini  
           c-estrut-mec-fim      = tt-param.c-estrut-mec-fim
           c-custo-ini           = tt-param.c-custo-ini
           c-custo-fim           = tt-param.c-custo-fim
           c-evento-ini          = tt-param.c-evento-ini      
           c-evento-fim          = tt-param.c-evento-fim      
           c-sub-sist-fim        = tt-param.c-sub-sist-fim    
           c-sub-sist-ini        = tt-param.c-sub-sist-ini    
           c-manut-ini           = tt-param.c-manut-ini       
           c-manut-fim           = tt-param.c-manut-fim       
           d-dat-inicial-ini     = tt-param.d-dat-inicial-ini 
           d-dat-inicial-fim     = tt-param.d-dat-inicial-fim 
           d-dat-final-ini       = tt-param.d-dat-final-ini   
           d-dat-final-fim       = tt-param.d-dat-final-fim
           c-empresa-matr-ini    = tt-param.c-empresa-matr-ini 
           c-empresa-matr-fim    = tt-param.c-empresa-matr-fim 
           c-estabel-matr-ini    = tt-param.c-estabel-matr-ini 
           c-estabel-matr-fim    = tt-param.c-estabel-matr-fim 
           c-cod-matr-ini        = tt-param.c-cod-matr-ini  
           c-cod-matr-fim        = tt-param.c-cod-matr-fim  
           l-EqptosMot           = tt-param.l-EqptosMot      
           l-EqptosNMot          = tt-param.l-EqptosNMot     
           l-EqptosAtivos        = tt-param.l-EqptosAtivos   
           l-EqptosInativos      = tt-param.l-EqptosInativos 
           l-EqptosProp          = tt-param.l-EqptosProp     
           l-EqptosTerc          = tt-param.l-EqptosTerc     
           l-EventNEn            = tt-param.l-EventNEnc     
           l-EventEncerr         = tt-param.l-EventEncerr    
           l-ManutOleo           = tt-param.l-ManutOleo      
           l-ManutFiltros        = tt-param.l-ManutFiltros   
           l-ManutMec            = tt-param.l-ManutMec       
           l-Custos              = tt-param.l-Custos         
           l-Outros              = tt-param.l-Outros
           l-insere              = tt-param.l-insere.         
                           
&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN c-cod-unid-negoc-ini = tt-param.c-cod-unid-negoc-ini
           c-cod-unid-negoc-fim = tt-param.c-cod-unid-negoc-fim.
&ENDIF

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

{utp/ut-liter.i Apontamentos_de_Eventos * L}
assign c-programa     = "ab0504"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = return-value
       c-sistema      = "".

run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo").

 CASE tt-param.classifica:
     WHEN 1 THEN DO:
      
        RUN pi-equipamento.
        {abp/ab0504.i2}
     END.

    WHEN 2 THEN DO:
        RUN pi-modelo.

        {abp/ab0504.i3}  

     END.
     WHEN 3 THEN DO:
        RUN pi-estab.

        {abp/ab0504.i4}
     END.
     WHEN 4  THEN DO:
          RUN pi-evento.

          {abp/ab0504.i5}
     END.
      WHEN 5  THEN DO:
          RUN pi-data.
          
          {abp/ab0504.i6}
     END.
      WHEN 6  THEN DO:
          RUN pi-sub-sist.

          {abp/ab0504.i7}
     END.
    &IF DEFINED(bf_mnt_ems206b) &THEN
        WHEN 7 THEN DO:
           RUN pi-unid-negoc.

           {abp/ab0504.i8}
        END.
    &ENDIF
 END CASE.

/*****Includes para Display dos Relat¢rios***/
 

 
         
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
      l-EqptosMot         colon 33 label "Equipamentos Motorizados"     format "Sim/NÆo"
      l-EqptosNMot        colon 33 label "Equipamentos NÆo Motorizados" format "Sim/NÆo"
      l-EqptosAtivos      colon 33 label "Equipamentos Ativos"          format "Sim/NÆo"
      l-EqptosInativos    colon 33 label "Equipamentos Inativos"        format "Sim/NÆo"
      l-EqptosProp        colon 33 label "Equipamentos Pr¢prios"        format "Sim/NÆo"
      l-EqptosTerc        colon 33 label "Equipamentos Terceiros"       format "Sim/NÆo"
      l-EventNEn          colon 33 label "Eventos NÆo Encerrados"       format "Sim/NÆo"
      l-EventEncerr       colon 33 label "Eventos Encerrados"           format "Sim/NÆo"
      l-ManutOleo         colon 33 label "Manuten‡Æo àleo"              format "Sim/NÆo"
      l-ManutFiltros      colon 33 label "Manuten‡Æo Filtros"           format "Sim/NÆo"
      l-ManutMec          colon 33 label "Manuten‡Æo Mercƒnica"         format "Sim/NÆo"
      l-Custos            colon 33 label "Custos"                       format "Sim/NÆo"
      l-Outros            colon 33 label "Outros"                       format "Sim/NÆo"
      l-insere            colon 33 label "Insere_Quebra_de_P gina"      format "Sim/NÆo"    
      with stream-io   overlay side-labels row 014 frame f-imp-par.
     /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par:HANDLE).
     
   
   {utp/ut-liter.i Equipamentos_Motorizados * L}
   assign l-EqptosMot:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Equipamentos_NÆo_Motorizados * L}
   assign  l-EqptosNMot:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Equipamentos_Ativos  * L}
   assign l-EqptosAtivos:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Equipamentos_Inativos * L}
   assign l-EqptosInativos:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Equipamentos_Pr¢prios * L}
   assign l-EqptosProp:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Equipamentos_Terceiros * L}
   assign  l-EqptosTerc:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Eventos_NÆo_Encerrados * L}
   assign  l-EventNEn:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Eventos_Encerrados  * L}
   assign  l-EventEncerr:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Manuten‡Æo_àleo * L}
   assign  l-ManutOleo:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Manuten‡Æo_Filtros * L}
   assign  l-ManutFiltros:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Manuten‡Æo_Mercƒnica * L}
   assign l-ManutMec:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Custos  * L}
   assign  l-Custos:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Outros  * L}
   assign l-Outros:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Insere_Quebra_de_P gina  * L}
   assign l-Insere:label in frame f-imp-par = return-value.
   


   disp 
     l-EqptosMot            
     l-EqptosNMot           
     l-EqptosAtivos        
     l-EqptosInativos 
     l-EqptosProp           
     l-EqptosTerc     
     l-EventNEn       
     l-EventEncerr    
     l-ManutOleo      
     l-ManutFiltros   
     l-ManutMec       
     l-Custos         
     l-Outros  
     l-Insere
     with frame f-imp-par.

   &IF DEFINED(bf_mnt_ems206b) &THEN
       {utp/ut-liter.i Unidade_Neg¢cio: * R}
       ASSIGN c-liter-un = TRIM(RETURN-VALUE).

       IF NOT l-usa-unid-negoc THEN
           ASSIGN cFaixa               = "":U
                  c-liter-un           = "":U
                  c-cod-unid-negoc-fim = "":U.
   &ENDIF
    
   {utp/ut-liter.i SELE€ÇO * C}
   PUT  unformatted skip(1) return-value format "x(30)" AT 26 skip.
   disp 

      c-empresa-ini         colon 33  "|< >|"  at 57 c-empresa-fim      no-label        
      c-eqpto-ini           colon 33  "|< >|"  at 57 c-eqpto-fim        no-label
      c-grupo-ini           colon 33  "|< >|"  at 57 c-grupo-fim        no-label
      c-modelo-ini          colon 33  "|< >|"  at 57 c-modelo-fim       no-label
      c-estabelec-ini       colon 33  "|< >|"  at 57 c-estabelec-fim    no-label
      c-tag-ini             colon 33  "|< >|"  at 57 c-tag-fim          no-label
      c-estrut-mec-ini      colon 33  "|< >|"  at 57 c-estrut-mec-fim   no-label        
      c-evento-ini          colon 33  "|< >|"  at 57 c-evento-fim       no-label
      c-sub-sist-ini        colon 33  "|< >|"  at 57 c-sub-sist-fim     no-label
      c-manut-ini           colon 33  "|< >|"  at 57 c-manut-fim        no-label
      d-dat-inicial-ini     colon 33  "|< >|"  at 57 d-dat-inicial-fim  no-label
      d-dat-final-ini       colon 33  "|< >|"  at 57 d-dat-final-fim    no-label
      c-empresa-matr-ini    LABEL "Motorista" COLON 33  "-" c-estabel-matr-ini NO-LABEL "-" c-cod-matr-ini NO-LABEL "|< >|" at 57 c-empresa-matr-fim NO-LABEL "-" c-estabel-matr-fim NO-LABEL "-" c-cod-matr-fim NO-LABEL
      c-custo-ini           colon 33  "|< >|"  at 57 c-custo-fim       no-label
      &IF DEFINED(bf_mnt_ems206b) &THEN
      c-liter-un             COLON 16   NO-LABEL 
      c-cod-unid-negoc-ini   COLON 33   NO-LABEL cFaixa NO-LABEL AT 57 
      c-cod-unid-negoc-fim              NO-LABEL
      &ENDIF
      WITH  WIDTH 132 stream-io side-labels overlay row 030 frame f-imp-sel.
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

