&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0508RP 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0508rp MAB}
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

{abp/ab0508.i}  
{include/pi-edit.i}

/* Recebimento de parametros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 6.63
         WIDTH              = 32.43.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* Include padroes para variaveis de relatorio */
{include/i-rpvar.i}

/* Include padrao para output de relatorios */
{include/i-rpout.i }
view frame f-cabec.
view frame f-rodape.

ASSIGN l-ViagemAnd     = tt-param.l-ViagemAnd     
       l-ViagemConcl   = tt-param.l-ViagemConcl   
       l-ViagemKmAc    = tt-param.l-ViagemKmAc    
       l-Insere        = tt-param.l-Insere        
       i-viagem-ini    = tt-param.i-viagem-ini    
       i-viagem-fim    = tt-param.i-viagem-fim    
       d-dt-saida-ini  = tt-param.d-dt-saida-ini  
       d-dt-saida-fim  = tt-param.d-dt-saida-fim  
       c-hr-saida-ini  = tt-param.c-hr-saida-ini  
       c-hr-saida-fim  = tt-param.c-hr-saida-fim  
       d-dt-ret-ini    = tt-param.d-dt-ret-ini    
       d-dt-ret-fim    = tt-param.d-dt-ret-fim    
       c-hr-ret-ini    = tt-param.c-hr-ret-ini    
       c-hr-ret-fim    = tt-param.c-hr-ret-fim    
       i-reserva-ini   = tt-param.i-reserva-ini   
       i-reserva-fim   = tt-param.i-reserva-fim   
       c-rota-ini      = tt-param.c-rota-ini      
       c-rota-fim      = tt-param.c-rota-fim      
       i-cod-emp-ini   = tt-param.i-cod-emp-ini   
       i-cod-emp-fim   = tt-param.i-cod-emp-fim   
       c-cod-eqpto-ini = tt-param.c-cod-eqpto-ini 
       c-cod-eqpto-fim = tt-param.c-cod-eqpto-fim 
       c-empresa-matr-ini = tt-param.c-empresa-matr-ini
       c-empresa-matr-fim = tt-param.c-empresa-matr-fim
       c-estabel-matr-ini = tt-param.c-estabel-matr-ini
       c-estabel-matr-fim = tt-param.c-estabel-matr-fim
       c-cod-matr-ini  = tt-param.c-cod-matr-ini  
       c-cod-matr-fim  = tt-param.c-cod-matr-fim.  

RUN piInicial IN THIS-PROCEDURE.

/* Include com a definicao da frame de cabecalho e rodape */
{include/i-rpcab.i }    

RUN piPrincipal IN THIS-PROCEDURE.

/*****Includes para Display dos Relat¢rios***/

CASE tt-param.classifica:
    WHEN 1 THEN DO:
        RUN pi-documento.
        {abp/ab0508.i2}
    END.

    WHEN 2 THEN DO:
        RUN pi-data-hora-saida.
        {abp/ab0508.i3}
    END.

    WHEN 3 THEN DO:
        RUN pi-data-hora-ret.
        {abp/ab0508.i4} 
    END.
     
    WHEN 4 THEN DO:
        RUN pi-equipamento.
        {abp/ab0508.i5}
     END.
     
     WHEN 5 THEN DO:
        RUN pi-grupo-equipamento.
        {abp/ab0508.i6}
     END.

END CASE.

/*Fechamento do output do relat¢rio*/
run pi-finalizar in h-acomp.
view frame f-cabec.
view frame f-rodape.
 
RUN displayParametros IN THIS-PROCEDURE.

{include/i-rpclo.i}

/** Finaliza o RP **/
return "OK":U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayParametros) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayParametros Procedure 
PROCEDURE displayParametros :
/*------------------------------------------------------------------------------
  Purpose:     displayParametros
  Parameters:  <none>
  Notes:       Mostra os parƒmetros selecionados
------------------------------------------------------------------------------*/
if  tt-param.parametro = YES then do: 
    PAGE.
     PUT SKIP (1).
     {utp/ut-liter.i PAR¶METROS * C}
     PUT  unformatted skip(1) return-value format "x(30)" AT 23 skip.
     form 
     l-ViagemAnd        colon 33 label "Viagens em Andamento"                         format "Sim/NÆo"
     l-ViagemConcl      colon 33 label "Viagens Conclu¡das"                           format "Sim/NÆo"
     l-ViagemKmAc       colon 33 label "KM Acima do estimado na Reserva"              format "Sim/NÆo"
     l-ImprimeObs       COLON 33 LABEL "Imprime Observa‡Æo"                           FORMAT "Sim/NÆo"
     l-Insere           colon 33 label "Insere Quebra de P gina"                      format "Sim/NÆo"
     with stream-io   overlay side-labels row 014 frame f-imp-par.
     /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
     RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par:HANDLE).
     

   
   {utp/ut-liter.i Viagens_em_ Andamento  * L}
   assign l-ViagemAnd:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Viagens_Conclu¡das  * L}
   assign  l-ViagemConcl:label in frame f-imp-par = return-value.
   {utp/ut-liter.i KM_acima_do_estimado_na_Reserva  * L}
   assign  l-ViagemKmAc:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Insere_Quebra_de_P gina  * L}
   assign   l-Insere:label in frame f-imp-par = return-value.
   {utp/ut-liter.i Imprime_Observa‡Æo  * L}
   assign   l-ImprimeObs:label in frame f-imp-par = return-value.


   disp 
     l-ViagemAnd    
     l-ViagemConcl 
     l-ViagemKmAc 
     l-ImprimeObs
     l-Insere     
     with frame f-imp-par.

   {utp/ut-liter.i SELE€ÇO * C}
   PUT  unformatted skip(1) return-value format "x(30)" AT 26 skip.
   disp 
      i-viagem-ini        colon 33  "|< >|"  at 57 i-viagem-fim        no-label
      d-dt-saida-ini      colon 33  "|< >|"  at 57 d-dt-saida-fim      no-label
      c-hr-saida-ini      colon 33  "|< >|"  at 57 c-hr-saida-fim      no-label
      d-dt-ret-ini        colon 33  "|< >|"  at 57 d-dt-ret-fim        no-label
      c-hr-ret-ini        colon 33  "|< >|"  at 57 c-hr-ret-fim        no-label   
      i-reserva-ini       colon 33  "|< >|"  at 57 i-reserva-fim       no-label
      c-rota-ini          colon 33  "|< >|"  at 57 c-rota-fim          no-label
      i-cod-emp-ini       colon 33  "|< >|"  at 57 i-cod-emp-fim       no-label
      c-cod-eqpto-ini     colon 33  "|< >|"  at 57 c-cod-eqpto-fim     no-label
      c-empresa-matr-ini LABEL "Motorista" COLON 33 "-" c-estabel-matr-ini NO-LABEL "-" c-cod-matr-ini NO-LABEL "|< >|"  at 57 c-empresa-matr-fim NO-LABEL "-" c-estabel-matr-fim NO-LABEL "-" c-cod-matr-fim NO-LABEL
      c-cod-grp-eqpto-ini colon 33  "|< >|"  at 57 c-cod-grp-eqpto-fim no-label
       with WIDTH 132 stream-io side-labels overlay row 030 frame f-imp-sel.
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

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piInicial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piInicial Procedure 
PROCEDURE piInicial :
/*------------------------------------------------------------------------------
  Purpose:     piInicial
  Parameters:  <none>
  Notes:       Define os valores que serÆo mostrados o cabe‡alho e rodap‚
------------------------------------------------------------------------------*/
blk_princ:
for each mab-viagem fields (cod-eqpto ep-codigo-matr cod-estabel-matr cod-matr  cod-rota hra-saida dat-ret hra-ret
         dat-saida ep-codigo  num-reserva num-viagem val-hodom-horim-inicial val-hodom-horim-final dsl-obs ) 
   WHERE mab-viagem.num-viagem  >= tt-param.i-viagem-ini     
    and  mab-viagem.num-viagem  <= tt-param.i-viagem-fim     
    and  mab-viagem.dat-saida   >= tt-param.d-dt-saida-ini   
    and  mab-viagem.dat-saida   <= tt-param.d-dt-saida-fim   
    and  mab-viagem.hra-saida   >= tt-param.c-hr-saida-ini   
    and  mab-viagem.hra-saida   <= tt-param.c-hr-saida-fim   
    and  mab-viagem.hra-ret     >= tt-param.c-hr-ret-ini     
    and  mab-viagem.hra-ret     <= tt-param.c-hr-ret-fim     
    and  mab-viagem.num-reserva >= tt-param.i-reserva-ini    
    and  mab-viagem.num-reserva <= tt-param.i-reserva-fim    
    and  mab-viagem.cod-rota    >= tt-param.c-rota-ini       
    and  mab-viagem.cod-rota    <= tt-param.c-rota-fim       
    and  mab-viagem.ep-codigo   >= tt-param.i-cod-emp-ini    
    and  mab-viagem.ep-codigo   <= tt-param.i-cod-emp-fim    
    and  mab-viagem.cod-eqpto   >= tt-param.c-cod-eqpto-ini  
    and  mab-viagem.cod-eqpto   <= tt-param.c-cod-eqpto-fim
    and  mab-viagem.ep-codigo-matr   >= tt-param.c-empresa-matr-ini
    and  mab-viagem.ep-codigo-matr   <= tt-param.c-empresa-matr-fim
    and  mab-viagem.cod-estabel-matr >= tt-param.c-estabel-matr-ini
    and  mab-viagem.cod-estabel-matr <= tt-param.c-estabel-matr-fim
    and  mab-viagem.cod-matr    >= tt-param.c-cod-matr-ini   
    and  mab-viagem.cod-matr    <= tt-param.c-cod-matr-fim NO-LOCK:
    

    if mab-viagem.num-reserva > 0 then do:
        FOR  FIRST mab-reserva FIELDS (num-reserva val-km-estimad) 
             WHERE mab-reserva.num-reserva = mab-viagem.num-reserva NO-LOCK:
        end.
        IF NOT AVAIL(mab-reserva) THEN next.
    end.


        FOR FIRST mab-eqpto WHERE mab-eqpto.ep-codigo = mab-viagem.ep-codigo
                          AND mab-eqpto.cod-eqpto = mab-viagem.cod-eqpto 
                          AND mab-eqpto.cod-grp-eqpto >= tt-param.c-cod-grp-eqpto-ini
                          AND mab-eqpto.cod-grp-eqpto <= tt-param.c-cod-grp-eqpto-fim 
                          NO-LOCK:
        END.
        IF NOT AVAIL(mab-eqpto) THEN NEXT.
        
        FOR FIRST empresa FIELDS (ep-codigo nome) 
           WHERE   empresa.ep-codigo  = mab-eqpto.ep-codigo NO-LOCK:
        END.
        IF NOT AVAIL(empresa) THEN NEXT.

        FOR FIRST mab-model FIELDS (cod-model des-model)
           WHERE mab-model.cod-model = mab-eqpto.cod-model  NO-LOCK:
        END.
        IF NOT AVAIL(mab-model) THEN NEXT.

        FOR FIRST mab-trajeto FIELDS (cod-rota des-rota) 
           WHERE mab-trajeto.cod-rota = mab-viagem.cod-rota NO-lock:
                 ASSIGN LocOrig = mab-trajeto.des-rota.
        END.
        IF NOT AVAIL(mab-trajeto) THEN NEXT.

        FOR FIRST mab-motoris 
            WHERE mab-motoris.ep-codigo   = mab-viagem.ep-codigo-matr
              AND mab-motoris.cod-estabel = mab-viagem.cod-estabel-matr 
              AND mab-motoris.cod-matr    = mab-viagem.cod-matr NO-LOCK:
        END.
        IF NOT AVAIL(mab-motoris) THEN NEXT.   
             
        ASSIGN KmEst      = mab-viagem.val-hodom-horim-final -  mab-viagem.val-hodom-horim-inicial
               cContador  = TRIM(STRING(mab-viagem.val-hodom-horim-inicial) + "/" + STRING(mab-viagem.val-hodom-horim-final)). 
             
        IF NOT(  (tt-param.l-ViagemAnd   = YES AND
                  mab-viagem.dat-ret = ? ) 
               OR 
                  (tt-param.l-ViagemConcl = YES AND 
                   mab-viagem.dat-ret <> ? AND  
                   mab-viagem.dat-ret >= tt-param.d-dt-ret-ini AND 
                   mab-viagem.dat-ret <= tt-param.d-dt-ret-fim )
               OR (tt-param.l-ViagemKmAc = YES AND 
                   avail mab-reserva AND 
                   KmEst > mab-reserva.val-km-estimad) 
               ) THEN NEXT.
        
        CREATE ttRelatViagem.
    
        ASSIGN ttRelatViagem.ep-codigo               = mab-viagem.ep-codigo              
               ttRelatViagem.cod-eqpto               = mab-viagem.cod-eqpto              
               ttRelatViagem.ep-codigo-matr          = mab-viagem.ep-codigo-matr
               ttRelatViagem.cod-estabel-matr        = mab-viagem.cod-estabel-matr
               ttRelatViagem.cod-matr                = mab-viagem.cod-matr               
               ttRelatViagem.cod-rota                = mab-viagem.cod-rota               
               ttRelatViagem.hra-saida               = mab-viagem.hra-saida              
               ttRelatViagem.dat-ret                 = mab-viagem.dat-ret                
               ttRelatViagem.hra-ret                 = mab-viagem.hra-ret                
               ttRelatViagem.dat-saida               = mab-viagem.dat-saida              
               ttRelatViagem.num-reserva             = mab-viagem.num-reserva            
               ttRelatViagem.num-viagem              = mab-viagem.num-viagem             
               ttRelatViagem.val-hodom-horim-inicial = mab-viagem.val-hodom-horim-inicial
               ttRelatViagem.val-hodom-horim-final   = mab-viagem.val-hodom-horim-final  
               ttRelatViagem.dsl-obs                 = mab-viagem.dsl-obs                 
               ttRelatViagem.cod-grp-eqpto           = mab-eqpto.cod-grp-eqpto
               ttRelatViagem.nom-motoris             = mab-motoris.nom-motoris
               ttRelatViagem.contador                = TRIM(STRING(mab-viagem.val-hodom-horim-inicial) + 
                                                            "/" + STRING(mab-viagem.val-hodom-horim-final))
               ttRelatViagem.des-model               = mab-model.des-model
               ttRelatViagem.nom-empresa             = empresa.nome.

END.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piPrincipal) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piPrincipal Procedure 
PROCEDURE piPrincipal :
/*------------------------------------------------------------------------------
  Purpose:     piPrincipal
  Parameters:  <none>
  Notes:       Corpo princiapl da aplica‡Æo
------------------------------------------------------------------------------*/
/* Bloco principal do programa */
find first param-global no-lock no-error.
if  available param-global THEN DO:
    FIND FIRST empresa WHERE empresa.ep-codigo = empresa-prin NO-LOCK NO-ERROR.
    if  available empresa THEN
        ASSIGN c-empresa = empresa.razao-social.
END.

find first tt-param.

{utp/ut-liter.i Apontamentos_de_Controle_de_Viagem * L}
assign c-programa     = "ab0508"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = return-value
       c-sistema      = "".



run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp (input "Imprimindo").

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

