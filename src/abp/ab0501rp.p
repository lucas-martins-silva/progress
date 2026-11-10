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
{include/i-prgvrs.i AB0501RP 2.00.00.008 } /*** 010008 ***/
{cdp/cdcfgmnt.i} /* Versäes EMS MNT */
{cdp/cd9911.i}  /* Varifica Unidade Neg¢cio */
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0501rp MAB}
&ENDIF


{include/i_fnctrad.i}
/********************************************************************************
**
**       PROGRAMA: ab0501rp.p
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
{abp/ab0501.i}  

/* Recebimento de parametros */
def input parameter raw-param as raw no-undo.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* Include padroes para variaveis de relatorio */
{include/i-rpvar.i}

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
         HEIGHT             = 18.08
         WIDTH              = 36.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */
{abp/ab0501.i2}   /* pi-equipamento   */
{abp/ab0501.i3}   /* pi-modelo        */
{abp/ab0501.i4}   /* pi-grupo         */
{abp/ab0501.i5}   /* pi-estrut-mec    */
{abp/ab0501.i6}   /* pi-estabelec     */
{abp/ab0501.i7}   /* pi-tag           */
{abp/ab0501.i8}   /* pi-proprietário  */
{abp/ab0501.i9}   /* pi-centrocusto   */
&IF DEFINED(bf_mnt_ems206b) &THEN
{abp/ab0501.i10}  /* pi-unid-negoc    */
&ENDIF

if connected("dthrpyc") then do:
    def var v_han_fpapi003 as handle no-undo.
    run prghur/fpp/fpapi003.p persistent set v_han_fpapi003 (input tt-param.usuario,
                                                             input tt-param.v_num_tip_aces_usuar).
END.

/** Parametriza padräes de cabe‡alho e rodap‚ a serem exibidos **/
run piInicial in this-procedure.
       
/** Imprime cabe‡alho e abre o output para arquivo **/
{include/i-rpcab.i}
{include/i-rpout.i}

/** Procedure para inicializar c lculos e impressÆo **/
run piPrincipal in this-procedure.

/** Fecha o output para arquivo **/
{include/i-rpclo.i}

return "OK":U. 
/*--- Fim do Programa ---*/

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
if  tt-param.l-param then do:
    page.
    PUT SKIP (1).
    {utp/ut-liter.i PAR¶METROS * C}
    PUT unformatted skip(1) return-value format "x(30)" AT 23 skip.
    FORM l-motorizados      colon 33     
         l-n-motorizados    colon 33   
         l-ativos           colon 33   
         l-Inativos         colon 33   
         l-proprios         colon 33   
         l-terceiros        colon 33   
         l-combust          colon 33   
         l-caract           colon 33
         l-comptes          colon 33   
         l-hist             colon 33   
         l-eventos          colon 33   
         l-planos           colon 33   
         l-config           colon 33   
         l-param            colon 33   
         l-Insere           colon 33
        with stream-io   overlay side-labels row 014 frame f-imp-par.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par:HANDLE).
    

    FORM l-matriz-un        colon 33   
         l-detalha-un       colon 33
        with stream-io   overlay side-labels row 014 frame f-imp-par-aux.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME f-imp-par-aux:HANDLE).
    

    {utp/ut-liter.i Motorizados  * L}
    assign l-motorizados:label in frame f-imp-par = return-value.

    {utp/ut-liter.i NÆo_Motorizados  * L}
    assign  l-n-motorizados:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Ativos  * L}
    assign  l-ativos:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Inativos  * L}
    assign    l-Inativos:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Pr¢prios  * L}
    assign l-proprios:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Terceiros  * L}
    assign l-terceiros:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Combust¡veis  * L}
    assign l-combust:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Caracter¡stica  * L}
    assign l-caract:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Compartimentos/Filtros  * L}
    assign l-comptes:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Hist¢rico_Transferˆncia  * L}
    assign l-hist:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Eventos_Programados  * L}
    assign l-eventos:label in frame f-imp-par = return-value.    
    {utp/ut-liter.i Planos_Manut_Preventiva  * L}
    assign l-planos:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Configura‡Æo_dos_Eixos  * L}
    assign l-config:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Imprimir_P g_de_Parƒmetros  * L}
    assign l-param:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Insere_Quebra_de_P gina  * L}
    assign l-Insere:label in frame f-imp-par = return-value.
    {utp/ut-liter.i Considerar_Matriz_Sele‡Æo * L}
    assign l-matriz-un:label in frame f-imp-par-aux = return-value.
    {utp/ut-liter.i Detalhar_Matriz * L}
    assign l-detalha-un:label in frame f-imp-par-aux = return-value.

    {utp/ut-liter.i Sim/NÆo}
    assign l-motorizados:FORMAT   in frame f-imp-par     = return-value
           l-n-motorizados:FORMAT in frame f-imp-par     = return-value
           l-ativos:FORMAT        in frame f-imp-par     = return-value       
           l-Inativos:FORMAT      in frame f-imp-par     = return-value     
           l-proprios:FORMAT      in frame f-imp-par     = return-value     
           l-terceiros:FORMAT     in frame f-imp-par     = return-value    
           l-combust:FORMAT       in frame f-imp-par     = return-value      
           l-caract:FORMAT        in frame f-imp-par     = return-value      
           l-comptes:FORMAT       in frame f-imp-par     = return-value      
           l-hist:FORMAT          in frame f-imp-par     = return-value         
           l-eventos:FORMAT       in frame f-imp-par     = return-value      
           l-planos:FORMAT        in frame f-imp-par     = return-value       
           l-config:FORMAT        in frame f-imp-par     = return-value       
           l-param:FORMAT         in frame f-imp-par     = return-value       
           l-Insere:FORMAT        in frame f-imp-par     = return-value
           l-matriz-un:FORMAT     in frame f-imp-par-aux = return-value
           l-detalha-un:FORMAT    in frame f-imp-par-aux = return-value.

    disp l-motorizados 
         l-n-motorizados 
         l-ativos       
         l-Inativos     
         l-proprios     
         l-terceiros    
         l-combust      
         l-caract
         l-comptes      
         l-hist         
         l-eventos      
         l-planos       
         l-config       
         l-param        
         l-Insere
        with frame f-imp-par.

    IF l-usa-unid-negoc THEN
        DISP l-matriz-un 
             l-detalha-un WITH FRAME f-imp-par-aux.

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
    disp i-cod-emp-ini   colon 25  "|< >|"  at 53 i-cod-emp-fim   at 59 no-label
         c-cod-eqpto-ini colon 25  "|< >|"  at 53 c-cod-eqpto-fim at 59 no-label
         c-grupo-ini     colon 25  "|< >|"  at 53 c-grupo-fim     at 59 no-label
         c-modelo-ini    colon 25  "|< >|"  at 53 c-modelo-fim    at 59 no-label
         c-estab-ini     colon 25  "|< >|"  at 53 c-estab-fim     at 59 no-label   
         c-tag-ini       colon 25  "|< >|"  at 53 c-tag-fim       at 59 no-label
         i-prop-ini      colon 25  "|< >|"  at 53 i-prop-fim      at 59 no-label   
         c-estr-mec-ini  colon 25  "|< >|"  at 53 c-estr-mec-fim  at 59 no-label
         c-ccusto-ini    colon 25  "|< >|"  at 53 c-ccusto-fim    at 59 no-label
         c-sit-ini       colon 25  "|< >|"  at 53 c-sit-fim       at 59 no-label
         i-ano-fab-ini   colon 25  "|< >|"  at 53 i-ano-fab-fim   at 59 no-label
         dat-cadastr-ini colon 25  "|< >|"  at 53 dat-cadastr-fim at 59 NO-LABEL         
        &IF DEFINED(bf_mnt_ems206b) &THEN
         c-liter-un             NO-LABEL COLON 8
         c-cod-unid-negoc-ini   NO-LABEL COLON 25   cFaixa NO-LABEL AT 53 
         c-cod-unid-negoc-fim   AT 59      NO-LABEL
        &ENDIF
        with stream-io side-labels overlay row 030 frame f-imp-sel.
                                                               
    {utp/ut-liter.i CLASSIFICA€ÇO * R}
    PUT  unformatted skip(1) return-value format "x(30)" AT 21 skip.
    disp desc-classifica  AT 35 NO-LABEL
        with stream-io side-labels overlay row 030 frame f-imp-cla.

    {utp/ut-liter.i IMPRESSÇO * C}
    PUT  unformatted skip(1) return-value format "x(30)" AT 25 skip.
    {utp/ut-liter.i Destino: * L}
    put unformatted skip "    " return-value format "x(10)" AT 23 v-cod-destino-impres " - " tt-param.arquivo format "x(40)".
    {utp/ut-liter.i Execu‡Æo: * L}
    put  unformatted skip "    " return-value format "x(12)" AT 22 if i-num-ped-exec-rpw = 0 then " On-Line" else " Batch".
    {utp/ut-liter.i Usu rio: * L}
    put  unformatted skip "    " return-value format "x(10)" AT 23 tt-param.usuario.

END.

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
/** Busca os parƒmetros criados na interface gr fica **/
find first tt-param.

/* Guarda os parƒmetros nas vari veis do relat¢rio */
ASSIGN l-motorizados   = tt-param.l-motorizados
       l-n-motorizados = tt-param.l-n-motorizados
       l-ativos        = tt-param.l-ativos
       l-Inativos      = tt-param.l-Inativos
       l-proprios      = tt-param.l-proprios
       l-terceiros     = tt-param.l-terceiros
       l-combust       = tt-param.l-combust
       l-caract        = tt-param.l-caract
       l-comptes       = tt-param.l-comptes        
       l-hist          = tt-param.l-hist           
       l-eventos       = tt-param.l-eventos        
       l-planos        = tt-param.l-planos         
       l-config        = tt-param.l-config         
       l-param         = tt-param.l-param          
       l-Insere        = tt-param.l-Insere         
       i-cod-emp-ini   = tt-param.i-cod-emp-ini    
       i-cod-emp-fim   = tt-param.i-cod-emp-fim    
       c-cod-eqpto-ini = tt-param.c-cod-eqpto-ini  
       c-cod-eqpto-fim = tt-param.c-cod-eqpto-fim  
       c-grupo-ini     = tt-param.c-grupo-ini      
       c-grupo-fim     = tt-param.c-grupo-fim      
       c-modelo-ini    = tt-param.c-modelo-ini     
       c-modelo-fim    = tt-param.c-modelo-fim     
       c-estab-ini     = tt-param.c-estab-ini      
       c-estab-fim     = tt-param.c-estab-fim       
       c-tag-ini       = tt-param.c-tag-ini        
       c-tag-fim       = tt-param.c-tag-fim     
       i-prop-ini      = tt-param.i-prop-ini
       i-prop-fim      = tt-param.i-prop-fim
       c-estr-mec-ini  = tt-param.c-estr-mec-ini   
       c-estr-mec-fim  = tt-param.c-estr-mec-fim   
       c-ccusto-ini    = tt-param.c-ccusto-ini     
       c-ccusto-fim    = tt-param.c-ccusto-fim     
       c-sit-ini       = tt-param.c-sit-ini        
       c-sit-fim       = tt-param.c-sit-fim        
       i-ano-fab-ini   = tt-param.i-ano-fab-ini    
       i-ano-fab-fim   = tt-param.i-ano-fab-fim
       dat-cadastr-ini = tt-param.dat-cadastr-ini 
       dat-cadastr-fim = tt-param.dat-cadastr-fim.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN c-cod-unid-negoc-ini = tt-param.c-cod-unid-negoc-ini
           c-cod-unid-negoc-fim = tt-param.c-cod-unid-negoc-fim
           l-matriz-un          = tt-param.l-matriz-un 
           l-detalha-un         = tt-param.l-detalha-un.
&ENDIF

find first param-global no-lock no-error.

if available param-global THEN DO:
    FIND FIRST empresa WHERE ep-codigo = empresa-prin NO-LOCK NO-ERROR.
    if available empresa THEN
        ASSIGN c-empresa = empresa.razao-social.
END.

{utp/ut-liter.i Listagem_de_Equipamentos * L}
assign c-programa     = "ab0501"
       c-versao       = "2.00"
       c-revisao      = "000"
       c-titulo-relat = return-value
       c-sistema      = "".

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
/** Mostra frames de cabe‡alho e rodap‚ padräes da Datasul **/
view frame f-cabec.
view frame f-rodape.

CASE tt-param.classifica:
    WHEN 1 THEN DO:
        RUN pi-equipamento IN THIS-PROCEDURE.
    END.
    WHEN 2 THEN DO:
        RUN pi-modelo IN THIS-PROCEDURE.
    END.
    WHEN 3 THEN DO:
       RUN pi-grupo IN THIS-PROCEDURE.
    END.
    WHEN 4 THEN DO:
       RUN pi-estrut-mec IN THIS-PROCEDURE.
    END.
    WHEN 5 THEN DO:
       RUN pi-estabelec IN THIS-PROCEDURE.
    END.
    WHEN 6 THEN DO:
       RUN pi-tag IN THIS-PROCEDURE.
    END.
    WHEN 7 THEN DO:
       RUN pi-proprietario IN THIS-PROCEDURE.
    END.
    WHEN 8 THEN DO:
       RUN pi-centrocusto IN THIS-PROCEDURE.
    END.
    &IF DEFINED(bf_mnt_ems206b) &THEN
    WHEN 9 THEN DO:
       RUN pi-unid-negoc IN THIS-PROCEDURE.
    END.
    &ENDIF
END CASE.

/** Inicializa programa de acompanhamento padrÆo Datasul **/
run utp/ut-acomp.p persistent set h-acomp.
run pi-inicializar in h-acomp(input c-titulo-relat).

/*********************************************************************
   Neste espa‡o deve-se colocar a l¢gica para busca as informa‡äes e 
   tamb‚m para fazer o display, pode-se inclui a chamada de procedures
   ou fazer a l¢gica neste espa‡o.
*********************************************************************/

/** L¢gica opcional do programador **/

/*********************************************************************
   Fim do espa‡o para l¢gica de c lculo e display das informa‡äes
*********************************************************************/

/** Mostra parƒmetros selecionados **/
run displayParametros in this-procedure.

/** Finaliza programa de acompanhamento padrÆo Datasul **/
run pi-finalizar in h-acomp.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

