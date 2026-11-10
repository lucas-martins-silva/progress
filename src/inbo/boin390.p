&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN390 2.00.01.025 } /*** "010125" 17/06/2025 16:40:49 ***/

/*--------------------------------------------------------------------------
    File       : 
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma
                 tabela do banco de dados.

    Parameters :

    Notes      : BO da tabela reservas
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName reservas
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions
&GLOBAL-DEFINE TableName reservas
&GLOBAL-DEFINE TableLabel reservas
&GLOBAL-DEFINE QueryName qr{&TableName}

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com
      extensÆo .i ---*/
{inbo/boin390.i RowObject}

{cdp/cdcfgman.i}

def var h-boin172  as handle no-undo.
def var h-boin189  as handle no-undo.
def var h-boin260  as handle no-undo.
def var h-boin270  as handle no-undo.
def var h-boin271  as handle no-undo.
def var h-boin375  as handle no-undo.
def var h-boin377  as handle no-undo.
def var h-boin682  as handle no-undo.
def var h-cpapi018 as handle no-undo.
def var h-cpapi013 as handle no-undo.
DEF VAR hBoSincroniz AS HANDLE NO-UNDO.


{inbo/boin172.i tt-item}
{inbo/boin189.i tt-localizacao}
{inbo/boin260.i tt-oper-ord}
{inbo/boin270.i tt-ord-manut}
{inbo/boin271.i tt-ord-prod}
{inbo/boin375.i tt-ref-item}
{inbo/boin377.i tt-referencia}
{inbo/boin390.i tt-reservas}
{inbo/boin682.i tt-param-global}

{cpp/cpapi018.i}
{cpp/cpapi013.i}
{cdp/cd0666.i}

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  {cep/ceapi030.i}
&endif

/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo
      manual da query ---*/
{method/dboqry.i}

/* Local Buffer Definitions ---                                            */
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


/* Variáveis necessárias aos setConstraint's */

define variable c-nr-ord-produ-aux as character no-undo.
define variable c-it-codigo        as character no-undo.
define variable l-nao-iniciadas    as logical    no-undo.
define variable l-liberadas        as logical    no-undo.
define variable l-alocadas         as logical    no-undo.
define variable l-separadas        as logical    no-undo.
define variable l-requisitadas     as logical    no-undo.
define variable l-iniciadas        as logical    no-undo.
define variable l-finalizadas      as logical    no-undo.
define variable l-terminadas       as logical    no-undo.
define variable l-canceladas       as logical    no-undo.
define variable c-estado           as character  no-undo.
define variable c-inicial          as character  no-undo.
define variable c-final            as character  no-undo.
define variable c-nr-ord-produ     as character  no-undo.
define variable c-it-codigo-reserva as char      no-undo.
define variable c-refer             as char      no-undo.
define variable d-data              as date      no-undo.
DEFINE VARIABLE iNrOrdProdu         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCdTarefa           AS INTEGER   NO-UNDO.
DEFINE VARIABLE c-desc-tudo AS CHARACTER   NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario AS CHARACTER FORMAT "x(12)" NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 3.17
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaReservas DBOProgram 
PROCEDURE atualizaReservas :
/*------------------------------------------------------------------------------
  Purpose:    Este procedimento tem por objetivo atualizar/criar as Reservas da Ordem de Produção
  Parameters: ipar01: c-param - Esta variável identifica se o usuário está incluindo, modificando ou eliminando.
              ipar02: tt-reservas - Esta tabela temporária está encarregada de trazer todos os registros dos campos informados
  
------------------------------------------------------------------------------*/
    define input parameter c-altera-quant-atend as CHAR no-undo.
    define input parameter c-param        as character no-undo.
    define input parameter param-wcp0302a as character no-undo.
    define input parameter ajuste         as character no-undo.
    define input parameter table for tt-reservas.
    
    define variable c-return       as character    no-undo.
    define variable de-aux         as decimal      no-undo.
    define variable de-quant-atend as decimal      no-undo.
    define variable de-saldo-aloca as decimal      no-undo.
    define variable de-quant-orig  as decimal      no-undo.

    FOR EACH tt-reservas:

        find first RowErrors no-lock no-error.
        if not available RowErrors then do:
            
            find FIRST reservas 
                 where reservas.nr-ord-produ = tt-reservas.nr-ord-produ
                   and reservas.item-pai     = tt-reservas.item-pai
                   and reservas.cod-roteiro  = tt-reservas.cod-roteiro
                   and reservas.op-codigo    = tt-reservas.op-codigo
                   and reservas.it-codigo    = tt-reservas.it-codigo
                  EXCLUSIVE-LOCK no-error.
            
            if c-param = "add" then do:
                if avail reservas then do:
                    /* Inicio -- Projeto Internacional */
                    {utp/ut-table.i movind reservas 1} /* Busca o label da tabela */
                    {method/svc/errors/inserr.i
                              &ErrorNumber="8"
                              &ErrorType="EMS"
                              &ErrorParameters=TRIM(RETURN-VALUE)}
                END.
            END.
            run verificaOrdem (input tt-reservas.nr-ord-produ).
          
            find first RowErrors no-lock no-error.
            if not available RowErrors then do:
    
            /*********************************** Valida Item **************************************/
    
                RUN inbo/boin172.p persistent set h-boin172.
                RUN findCodigo in h-boin172 (input tt-reservas.it-codigo, output c-return). 
                if c-return <> "" then do:
        		  {utp/ut-table.i mgcad item 1}
                  {method/svc/errors/inserr.i
                          &ErrorNumber="2"
                          &ErrorType="EMS"
                          &ErrorParameters=RETURN-VALUE}      
                END.
                else do:
                
                    RUN getCurrent in h-boin172 (output table tt-item).
        
                    /********************************* Valida Referï¿½ncia **********************************/
                  
                    FIND FIRST tt-item NO-LOCK NO-ERROR.
                    IF AVAIL tt-item THEN DO:
                        if tt-item.tipo-con-est = 4 then do:
                            RUN inbo/boin375.p persistent set h-boin375.
                            RUN findItem in h-boin375 (input tt-reservas.it-codigo, tt-reservas.cod-refer, output c-return). 
            
                            if c-return <> "" then do:
                              {utp/ut-table.i mgcad referencia 1}
                              {method/svc/errors/inserr.i
                                        &ErrorNumber="529" /* Referencia nï¿½o encontrada no sistema */
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"} 
                            END.
                            delete procedure h-boin375.
                            
                            IF c-param = "mod"
                             AND reservas.nr-req-sum <> 0
                             AND reservas.cod-refer  <> tt-reservas.cod-refer
                             THEN DO:
                                {utp/ut-liter.i "OP Sumarizada. Para alterar ser  necess rio exclusÆo a sumariza‡Æo." *}
                                {method/svc/errors/inserr.i
                                        &ErrorNumber="17567" /* Referencia nÆo encontrada no sistema */
                                        &ErrorType="EMS"
                                        &ErrorParameters="RETURN-VALUE"} 
                            
                            END.                                                    
                        END.
                        ELSE ASSIGN tt-reservas.cod-refer = "".                             
        
                    /********************************* Valida Lote/Sï¿½rie **********************************/
        
                        if tt-item.tipo-con-est > 1 then
                            assign tt-reservas.lote-serie = tt-reservas.lote-serie.
                        else
                            assign tt-reservas.lote-serie = "".
            
                /********************************* Valida Estado do Item *************************************/
    
                        if tt-item.cod-obsoleto = 3 then do:
                            
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Item" *}
                            ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="563" /* Item &1 estï¿½ obsoleto */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-item"}
                                      
                        END.
        
                /******************************* Valida Unidade de Medida ************************************/
    
                        if tt-item.un <> tt-reservas.un then do:
                            
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-unidade-medida AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Unidade_Medida" *}
                            ASSIGN c-lbl-liter-unidade-medida = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="848"
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-unidade-medida"}
                                    
                        END.
    
                /*************************** Valida Tipo de Requisiï¿½ï¿½o do Item *******************************/
        
                        if tt-item.tipo-requis = 3 then do:
                            
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-item-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Item" *}
                            ASSIGN c-lbl-liter-item-2 = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="1675" /* Item nï¿½o pode ser de tipo de requisiï¿½ï¿½o Dï¿½bito GGF */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-item-2"}
                        END.
        
                /**************************** Valida Tipo de Controle do Item ********************************/
        
                        if tt-item.tipo-contr = 4 then do:
                              
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-item-3 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Item" *}
                            ASSIGN c-lbl-liter-item-3 = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="1673" /* Item nï¿½o pode ser de dï¿½bito direto */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-item-3"}
                        end.
        
                /****************************** Valida Item Fraciona ou Nï¿½o? *********************************/
        
                        if tt-item.fraciona = no and 
                            decimal(tt-reservas.quant-orig) <> integer(tt-reservas.quant-orig) then do:
                            
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-qtde-reserva AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Quantidade_Reserva" *}
                            ASSIGN c-lbl-liter-qtde-reserva = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="847" /* Quantidade deve ser um valor inteiro */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-qtde-reserva"}
                        end.
        						
    		    /****************************** Validacoes controle de potencia *********************************/
    			
    				    FIND FIRST param-global NO-LOCK NO-ERROR.
    						
    					if param-global.modulo-per-ppm THEN DO:
    												
                            IF tt-reservas.quant-orig < 0
                              AND tt-item.tipo-formula >= 2 
                              AND tt-item.tipo-formula <= 4 then do:	
    								
        						DEFINE VARIABLE c-lbl-liter-qtd-veiculo AS CHARACTER NO-UNDO.
        								
                                ASSIGN c-lbl-liter-qtd-veiculo = tt-item.it-codigo + "~~" + {ininc/i25in172.i 04 tt-item.tipo-formula}.
                                {method/svc/errors/inserr.i
                                       &ErrorNumber="27296" /* Quantidade Componete do item nao pode ser Negativa ! */
                                       &ErrorType="EMS":U
                                       &ErrorParameters="c-lbl-liter-qtd-veiculo"}
                            
                            END.
    
                            IF tt-reservas.veiculo 
                                AND tt-reservas.per-ppm <= 0 THEN DO:
                                
                                DEFINE VARIABLE c-lbl-liter-qtd-ppm AS CHARACTER NO-UNDO.
                                
                                {utp/ut-liter.i %_Distrib._Veículo *}
                                
                                ASSIGN c-lbl-liter-qtd-ppm = RETURN-VALUE.
                                
                                {method/svc/errors/inserr.i
                                       &ErrorNumber="2333" /* % Distrib. Veiculo nao pode ser zero! */
                                       &ErrorType="EMS":U
                                       &ErrorParameters="c-lbl-liter-qtd-ppm"}								
                            END.
                        END.
    
                /********************************** Valida o Tipo de Sobra ***********************************/
        
                        if tt-reservas.quant-orig > 0 and 
                            tt-reservas.tipo-sobra <> 4 then do:
                            
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-tipo-sobra AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Tipo_Sobra" *}
                            ASSIGN c-lbl-liter-tipo-sobra = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="158" /* Informe um Tipo de Sobra Vï¿½lido */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-tipo-sobra"}
                        END.
        
                /******************************* Valida a Quantidade Original ********************************/
        
                        if tt-reservas.quant-orig = 0 then do:
                            
                            /* Inicio -- Projeto Internacional */
                            DEFINE VARIABLE c-lbl-liter-qtde-reserva-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "Quantidade_reserva" *}
                            ASSIGN c-lbl-liter-qtde-reserva-2 = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i
                                    &ErrorNumber="1368"  /* Quantidade deve ser maior que zero */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-lbl-liter-qtde-reserva-2"}
                        END.
        
                /******************************* Valida o Roteiro e a Operaï¿½ï¿½o *******************************/
        
                        if tt-reservas.cod-roteiro <> "" or tt-reservas.op-codigo <> 0 then do:
                              RUN inbo/boin260.p persistent set h-boin260.
                              RUN findCodigo in h-boin260 (input tt-reservas.nr-ord-produ, input tt-reservas.item-pai, input tt-reservas.cod-roteiro, input tt-reservas.op-codigo, output c-return).                                  
                              if c-return <> " " then do:
                                      {method/svc/errors/inserr.i
                                              &ErrorNumber="1685"  /* Operaï¿½ï¿½o nï¿½o cadastrada para a Reserva */
                                              &ErrorType="EMS":U
                                       }
                              END.
                              delete procedure h-boin260.
                        END.
                    END.
        
                    /************ Valida se o mï¿½dulo de Planejamento e o Mï¿½dulo de Planejamento da ***************/
                    /************            Manutenï¿½ï¿½o Industrial estï¿½o implantados               ***************/
                    FIND FIRST tt-ord-prod NO-ERROR.  
                
                    IF AVAIL tt-ord-prod THEN DO:    
                           
                        RUN inbo/boin682.p persistent set h-boin682.
                        RUN openQuery in h-boin682 (1).
                        RUN getCurrent in h-boin682 (output table tt-param-global).
                        FIND FIRST tt-param-global NO-ERROR.
                        IF AVAIL tt-param-global THEN DO:
                            if tt-param-global.modulo-pl = yes and
    					       tt-param-global.modulo-pi = yes then do:
    
                                run cdp/cd7000.p (0,
                                          tt-reservas.it-codigo,
                                          tt-ord-prod.cod-estabel). /* usado p/ planejamento */
                                run cdp/cd7000.p (0,
                                          tt-ord-prod.it-codigo,
                                          tt-ord-prod.cod-estabel). /* usado p/ planejamento */
                            END.
                        END.
    			     	delete procedure h-boin682.
    
                /************************ Carrega os dados da Ordem de Produï¿½ï¿½o da Reserva *******************/
        
                        RUN inbo/boin271.p persistent set h-boin271.
                        RUN findCodigo in h-boin271 (input tt-reservas.nr-ord-produ, output c-return).
                        if c-return <> " " then do:
                          {utp/ut-table.i movind ord-prod 1}
                          {method/svc/errors/inserr.i
                                  &ErrorNumber="2"  
                                  &ErrorType="EMS":U
                                  &ErrorParameters="RETURN-VALUE"}
                        END.
                        else do:
        
                /******************************* Valida a Data da Reserva ************************************/
    
                            if tt-reservas.dt-reserva < tt-ord-prod.dt-inicio                or
                               tt-reservas.dt-reserva > tt-ord-prod.dt-termino         then do:
                                ASSIGN c-desc-tudo = STRING(tt-ord-prod.dt-inicio) + '~~' + STRING(tt-ord-prod.dt-termino).
                                /* Inicio -- Projeto Internacional */
                                {method/svc/errors/inserr.i
                                    &ErrorNumber="1692" /* Data reserva deve estar entre o inï¿½cio e o tï¿½rmino da Ordem */
                                    &ErrorType="EMS":U
                                    &ErrorParameters="c-desc-tudo"}
                                  
                            END.
                /*********************************** Valida Localizaï¿½ï¿½o **************************************/
                     
                            if tt-item.loc-unica = yes then
                                assign tt-reservas.cod-localiz = tt-item.cod-localiz.
                            else do:
                                RUN inbo/boin189.p persistent set h-boin189.
                                RUN findCodigo in h-boin189 (input tt-ord-prod.cod-estabel, input tt-reservas.cod-depos, input tt-reservas.cod-localiz, output c-return).
                                if c-return <> " " then do:													
            												
                                  {utp/ut-table.i mgcad localizacao 1}
                                  {method/svc/errors/inserr.i
                                              &ErrorNumber="2"  
                                              &ErrorType="EMS":U
                                              &ErrorParameters="RETURN-VALUE"}
                                END.
    
                                IF VALID-HANDLE(h-boin189) THEN
                                    DELETE PROCEDURE h-boin189.
                            END.
                  /************************* Valida se o item da reserva nï¿½o ï¿½ o Item da Ordem *****************/
    
                            if tt-reservas.it-codigo = tt-ord-prod.it-codigo and
                                                       tt-ord-prod.tipo <> 5 and 
                                                       tt-ord-prod.tipo <> 9 then do:
                                                  
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-item-4 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Item" *}
                                ASSIGN c-lbl-liter-item-4 = TRIM(RETURN-VALUE).
                                {method/svc/errors/inserr.i
                                        &ErrorNumber="1677" /* Item deve ser diferente do item da ordem */
                                        &ErrorType="EMS":U
                                        &ErrorParameters="c-lbl-liter-item-4"}
                            END.
                        END.
                /*******************Fim da Validaï¿½ï¿½o se o item da reserva nï¿½o ï¿½ o Item da Ordem****************/
    
                /*************************** Valida se a Quantidade Atendida foi alterada *********************/
    
                        if c-param="mod" then do:
    
                            find first {&TABLENAME} where {&TABLENAME}.nr-ord-produ = tt-reservas.nr-ord-produ
                                   and {&tablename}.it-codigo = tt-reservas.it-codigo NO-LOCK no-error.
                                                                                                  
                            assign de-quant-atend = {&TABLENAME}.quant-atend.
    
                            if param-wcp0302a = '1' or param-wcp0302a = ""
                              and de-quant-atend <> decimal(tt-reservas.quant-atend)
                              and c-altera-quant-atend = "no" then do:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-quantidade-atendida-nao-pode-s AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Quantidade_Atendida_não_pode_ser_alterada" *}
                                ASSIGN c-lbl-liter-quantidade-atendida-nao-pode-s = TRIM(RETURN-VALUE).
                                ASSIGN c-desc-tudo = c-lbl-liter-quantidade-atendida-nao-pode-s + '!'.
                                {method/svc/errors/inserr.i
                                            &ErrorNumber="17242"  /*Mensagem de erro branca*/
                                            &ErrorType="EMS":U
                                            &ErrorParameters="c-desc-tudo"}
                            END.
                        END.
                        assign de-aux = tt-reservas.quant-orig.
                        /*end.*/
        
                        assign tt-reservas.tp-atualiza = 0.
        
                        if c-param = "mod" then do:                                                                                     
                            if param-wcp0302a = "2" then do:
                                assign tt-reservas.quant-orig = tt-reservas.quant-orig + DECIMAL(ajuste).
                            end.
                        end.
                        else do:
                            if tt-reservas.quant-aloc > tt-reservas.quant-orig then
                                assign de-saldo-aloca = tt-reservas.quant-aloc - tt-reservas.quant-orig.
                            else
                                assign de-saldo-aloca = tt-reservas.quant-orig - tt-reservas.quant-aloc.
                        end.
    
                        find first RowErrors no-lock no-error.
                        if not available RowErrors then do:
    
                            /*Incluï¿½do para alterar todos os campos da reserva*/
        									  
                            IF c-param = "mod" THEN
                                FIND current {&TABLENAME} EXCLUSIVE-LOCK NO-ERROR.
            									  
                            IF NOT AVAIL reservas AND c-param = "add" THEN
                                CREATE reservas.
                      
                            buffer-copy tt-reservas except per-ppm to reservas.
                            assign reservas.per-ppm = IF reservas.veiculo THEN tt-reservas.per-ppm ELSE tt-item.per-ppm.
            
                            ASSIGN de-quant-orig = reservas.quant-orig.                     
                                          

                            /*run validateUpdate (input table tt-reservas).*/
            
                            /***** Atualiza a REQ-SUM ****/
                      
                            if tt-ord-prod.nr-req-sum <> 0 and
                               tt-item.tipo-requis = 1 then do:
                                                                    
                                if not valid-handle (h-cpapi018) then
                                    run cpp/cpapi018.p persistent set h-cpapi018 (input        table tt-dados,
                                                                                  input        table tt-ord-prod-2,
                                                                                  input-output table tt-req-sum,
                                                                                  input-output table tt-erro,
                                                                                  input        yes).
                                                    
                                run pi-atualiza-quantidade in h-cpapi018 (input rowid(reservas),
                                                                          input de-quant-orig).
            
                            END.
                        END.
                    END.
                END. /*Finalizada a condiï¿½ï¿½o da Ordem de Produï¿½ï¿½o*/                        
            END.
            delete procedure h-boin271.
            delete procedure h-boin172.
         END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDestroy DBOProgram 
PROCEDURE beforeDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if valid-handle (h-cpapi018) then
        run pi-finalizar in h-cpapi018.
		
	if valid-handle (h-cpapi013) then
        run pi-finalizar in h-cpapi013.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaQuantidadesReservas DBOProgram 
PROCEDURE calculaQuantidadesReservas :
/*------------------------------------------------------------------------------
  Purpose:   Calcula quantidade da falta do item, quantidade disponível 
             alocada, quantidade da falta alocada, saldo e quantidade total
             alocada das reservas do item.
  Parameters:ipar1:p-nr-ordem: Ordem Produção
             ipar2:p-it-codigo:Item Reserva
             ipar3:l-saldo-terc:Saldo Terceiros
             opar1:de-falta-item:Falta Item
             opar2:de-disp-aloc:Disponível Alocada
             opar3:de-falta-aloc:Falta Alocada
             opar4:de-saldo:Saldo
             opar5:de-tot-aloc:Total Alocada    
------------------------------------------------------------------------------*/
    define input  parameter p-nr-ordem    as int     no-undo.
    define input  parameter p-it-codigo   as char    no-undo.
    define input  parameter l-saldo-terc  as log     no-undo.
    define output parameter de-falta-item as decimal no-undo.
    define output parameter de-disp-aloc  as decimal no-undo.
    define output parameter de-falta-aloc as decimal no-undo.
    define output parameter de-saldo      as decimal no-undo.
    define output parameter de-tot-aloc   as decimal no-undo.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    def var l-lote-avancado as log    no-undo.
    def var h-ceapi030      as handle no-undo.
    def var l-retorno       as log    no-undo.

    if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                             funcao.ativo) then do:
        assign l-lote-avancado = yes.

        if not valid-handle(h-ceapi030) then
            run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                          output table tt-valores,
                                                          output table tt-erro).
    end.
  &endif
    
    for each {&TABLENAME} fields (nr-ord-produ it-codigo 
                                  quant-orig quant-aloc quant-atend)
        where {&TABLENAME}.nr-ord-produ = p-nr-ordem  
        and   {&tablename}.it-codigo    = p-it-codigo:
        
        for each  saldo-estoq fields (it-codigo   cod-depos  qtidade-atu
                                      qt-alocada  qt-aloc-ped) use-index dep-estabel
          where saldo-estoq.it-codigo = {&tablename}.it-codigo no-lock,
           each deposito fields (cod-depos   cons-saldo) use-index deposito
          where deposito.cod-depos = saldo-estoq.cod-depos           
            and deposito.alocado no-lock:

          &if '{&bf_lote_avancado_liberado}' = 'yes' &then
            assign l-retorno = yes.

            find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
            if l-lote-avancado and
               avail item and
               item.tipo-con-est > 2 then do:

                run pi-identifica-saldo in h-ceapi030 (input 1,
                                                       input saldo-estoq.it-codigo,
                                                       input saldo-estoq.cod-estabel,
                                                       input saldo-estoq.lote,
                                                       input 0,
                                                       output l-retorno,
                                                       output table tt-valores2,
                                                       output table tt-erro).

            end.

            if l-retorno then
          &endif

            assign de-saldo = de-saldo + (saldo-estoq.qtidade-atu
                            - saldo-estoq.qt-alocada - saldo-estoq.qt-aloc-ped).                  
        end.  
      
        if  l-saldo-terc then do: 
            for each  saldo-terc fields (it-codigo   cod-depos   quantidade)
                where saldo-terc.it-codigo = {&tablename}.it-codigo no-lock,
                 each deposito fields (cod-depos   cons-saldo)
                where deposito.cod-depos = saldo-terc.cod-depos
                  and deposito.alocado no-lock:

              &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                assign l-retorno = yes.
    
                find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
                if l-lote-avancado and
                   avail item and
                   item.tipo-con-est > 2 then do:
    
                    run pi-identifica-saldo in h-ceapi030 (input 1,
                                                           input saldo-terc.it-codigo,
                                                           input saldo-terc.cod-estabel,
                                                           input saldo-terc.lote,
                                                           input 0,
                                                           output l-retorno,
                                                           output table tt-valores2,
                                                           output table tt-erro).
    
                end.
    
                if l-retorno then
              &endif
                  
                assign de-saldo = de-saldo + saldo-terc.quantidade.
             end.       
        end.
         
        for each aloca-reserva fields(it-codigo  quant-aloc)
           where aloca-reserva.it-codigo = {&tablename}.it-codigo no-lock:
            
            assign de-tot-aloc = de-tot-aloc + aloca-reserva.quant-aloc.  
        end.
        
        assign de-disp-aloc  = de-saldo - de-tot-aloc
               de-falta-aloc = {&TABLENAME}.quant-orig - {&TABLENAME}.quant-aloc
               de-falta-item = {&TABLENAME}.quant-orig - {&TABLENAME}.quant-aloc - de-saldo - {&TABLENAME}.quant-atend
               de-tot-aloc   = de-tot-aloc
               de-saldo      = de-saldo.
 
      if  de-falta-item < 0 then 
          assign de-falta-item = 0.
    end.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
     if valid-handle(h-ceapi030) then
         delete procedure h-ceapi030.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaTotais DBOProgram 
PROCEDURE calculaTotais :
/*------------------------------------------------------------------------------
  Purpose:    Calcula o total da quantidade de reserva, quantidade atendida,
              quantidade alocada e quantidade atual do item.    
  Parameters: ipar:p-it-codigo: Item reserva
              opar1:p-quant-orig:Qtde reserva
              opar2:p-quant-atend:Qtde Atendida
              opar3:p-quant-aloc:Qtde Alocada
              opar4:p-quant-atu:Qtde Atual
 ------------------------------------------------------------------------------*/
    define input  parameter p-it-codigo   as char.
    define output parameter p-quant-orig  as decimal.
    define output parameter p-quant-atend as decimal.
    define output parameter p-quant-aloc  as decimal.
    define output parameter p-quant-atu   as decimal.
    define var de-saldo as decimal.
    
    assign de-saldo      = 0
           p-quant-orig  = 0
           p-quant-atend = 0
           p-quant-aloc  = 0
           p-quant-atu   = 0.
    
    for each {&TABLENAME} fields(nr-ord-produ it-codigo quant-orig quant-atend quant-aloc) 
       where {&tablename}.it-codigo = p-it-codigo,
       first ord-prod FIELDS(ord-prod.nr-ord-produ ord-prod.estado)
         where ord-prod.nr-ord-produ = {&TABLENAME}.nr-ord-produ and
             ((ord-prod.estado = 1 and l-nao-iniciadas)  or
              (ord-prod.estado = 2 and l-liberadas    )  or   
              (ord-prod.estado = 3 and l-alocadas     )  or
              (ord-prod.estado = 4 and l-separadas    )  or 
              (ord-prod.estado = 5 and l-requisitadas )  or
              (ord-prod.estado = 6 and l-iniciadas    )  or
              (ord-prod.estado = 7 and l-finalizadas  )  or
              (ord-prod.estado = 8 and l-terminadas   )) no-lock:
       
        assign de-saldo      = ({&TABLENAME}.quant-orig - {&TABLENAME}.quant-atend - {&TABLENAME}.quant-aloc)
               p-quant-orig  = p-quant-orig  + {&TABLENAME}.quant-orig
               p-quant-atend = p-quant-atend + {&TABLENAME}.quant-atend
               p-quant-aloc  = p-quant-aloc  + {&TABLENAME}.quant-aloc
               p-quant-atu   = p-quant-atu   + de-saldo. 
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findCodigo DBOProgram 
PROCEDURE findCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters: ipar1:i-nr-ord-produ:Ordem Produção
              ipar2:c-it-codigo:   Item
       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter  i-nr-ord-produ as integer   no-undo.
    def input parameter  c-it-codigo    as character no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goToCodigo(input i-nr-ord-produ,
                   input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        {utp/ut-table.i movind {&TABLENAME} 1}
        run utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findOperacao DBOProgram 
PROCEDURE findOperacao :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters: ipar1:i-nr-ord-produ:Ordem Produção
              ipar2:c-item-pai:Item Pai
              ipar3:c-cod-roteiro:Roteiro
              ipar4:i-op-codigo:Operação
              ipar5:c-it-codigo:Item Reserva  
  ------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    def input parameter i-nr-ord-produ as inte no-undo.
    def input parameter c-item-pai as char no-undo.
    def input parameter c-cod-roteiro as char no-undo.
    def input parameter i-op-codigo as inte no-undo.
    def input parameter c-it-codigo as char no-undo.
    def output parameter pcreturn as char no-undo.
        
        
    RUN openQueryStatic (input "Main":U).
    
    run goTokey (input i-nr-ord-produ,
                 input c-item-pai,
                 input c-cod-roteiro,
                 input i-op-codigo,
                 input c-it-codigo).

    if return-value = "OK" then assign pcreturn = "".  /* esse e o valor esperado nas interfaces 1.1 */
    if return-value = "NOK" then do:
        /*{utp/ut-table.i movind {&TABLENAME} 1}*/
        run utp/ut-msgs.p (input "msg":U,
                           input 1680,
                           input return-value).
        assign pcreturn =  return-value.  
        /* essa e a mensagem esperada nas interfaces 1.1  qdo nÆo acha o registro */
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findQtdOrig DBOProgram 
PROCEDURE findQtdOrig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar:p-ord-prod:Ordem Produção
------------------------------------------------------------------------------*/
    define input  parameter  p-ord-prod as integer no-undo.
    define output parameter  table for tt-reservas.
        
       for each {&TABLENAME}
        where   {&TABLENAME}.nr-ord-produ = p-ord-prod and
                {&TABLENAME}.estado = 1 no-lock :
           create tt-reservas.
           buffer-copy {&TABLENAME} to tt-reservas. 
       end.
     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findQtdOrigOper DBOProgram 
PROCEDURE findQtdOrigOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar01: p-ord-prod:Ordem Produ‡Æo
              ipar02: p-op-codigo-ini: Opera‡Æo da Reserva inicial
              ipar03: p-op-codigo-fim: Opera‡Æo da Reserva final
              opar01: Retorna tt-reservas
------------------------------------------------------------------------------*/
    define input parameter p-ord-prod  as integer no-undo.
    define input parameter p-op-codigo-ini as integer no-undo.
    define input parameter p-op-codigo-fim as integer no-undo.
    define output parameter  table for tt-reservas.
        
       for each {&TABLENAME}
        where   {&TABLENAME}.nr-ord-produ = p-ord-prod  and
                {&TABLENAME}.estado = 1 and
                {&TABLENAME}.op-codigo   >= p-op-codigo-ini and
                {&TABLENAME}.op-codigo   <= p-op-codigo-fim or
                {&TABLENAME}.nr-ord-produ = p-ord-prod  and
                {&TABLENAME}.estado = 1 and
                {&TABLENAME}.op-codigo   = 0
                no-lock :
           create tt-reservas.
           buffer-copy {&TABLENAME} to tt-reservas. 
       end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE forItem DBOProgram 
PROCEDURE forItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters: ipar:p-it-codigo:Item Reserva 
 ------------------------------------------------------------------------------*/
    define input  parameter  p-it-codigo as char no-undo.
    define output parameter  table for tt-reservas.
        
       for each {&TABLENAME}
        where   {&tablename}.it-codigo begins p-it-codigo and
                {&TABLENAME}.estado = 1 no-lock :
           create tt-reservas.
           buffer-copy {&TABLENAME} to tt-reservas. 
       end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateOrdManutSincroniz DBOProgram 
PROCEDURE updateOrdManutSincroniz:
    DEFINE INPUT PARAMETER p-iNrOrdProdu AS INTEGER NO-UNDO.

    RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.
    RUN adicionarSincroniz IN hBoSincroniz (INPUT "ord-manut":U,
                                            INPUT STRING(p-iNrOrdProdu),
                                            INPUT 2, /* Update */
                                            INPUT c-seg-usuario).

    IF VALID-HANDLE (hBoSincroniz) THEN
        DELETE OBJECT hBoSincroniz.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     afterCreateRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN updateOrdManutSincroniz (INPUT reservas.nr-ord-produ).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     afterUpdateRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN updateOrdManutSincroniz (INPUT reservas.nr-ord-produ).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     afterDeleteRecord
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN updateOrdManutSincroniz (INPUT iNrOrdProdu).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "lote-serie":U THEN ASSIGN pFieldValue = RowObject.lote-serie.
        WHEN "un":U THEN ASSIGN pFieldValue = RowObject.un.
        WHEN "cd-lubr":U THEN ASSIGN pFieldValue = RowObject.cd-lubr.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "item-pai":U THEN ASSIGN pFieldValue = RowObject.item-pai.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "cod-refer":U THEN ASSIGN pFieldValue = RowObject.cod-refer.
        WHEN "cod-roteiro":U THEN ASSIGN pFieldValue = RowObject.cod-roteiro.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-reserva":U THEN ASSIGN pFieldValue = RowObject.dt-reserva.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "quant-aloc":U THEN ASSIGN pFieldValue = RowObject.quant-aloc.
        WHEN "quant-aplic":U THEN ASSIGN pFieldValue = RowObject.quant-aplic.
        WHEN "quant-atend":U THEN ASSIGN pFieldValue = RowObject.quant-atend.
        WHEN "quant-orig":U THEN ASSIGN pFieldValue = RowObject.quant-orig.
        WHEN "quant-requis":U THEN ASSIGN pFieldValue = RowObject.quant-requis.
        WHEN "quant-terc":U THEN ASSIGN pFieldValue = RowObject.quant-terc.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "nr-ord-produ":U THEN ASSIGN pFieldValue = RowObject.nr-ord-produ.
        WHEN "nr-ord-refer":U THEN ASSIGN pFieldValue = RowObject.nr-ord-refer.
        WHEN "nr-req-sum":U THEN ASSIGN pFieldValue = RowObject.nr-req-sum.
        WHEN "op-codigo":U THEN ASSIGN pFieldValue = RowObject.op-codigo.
        WHEN "origem":U THEN ASSIGN pFieldValue = RowObject.origem.
        WHEN "tipo-sobra":U THEN ASSIGN pFieldValue = RowObject.tipo-sobra.
        WHEN "tp-atualiza":U THEN ASSIGN pFieldValue = RowObject.tp-atualiza.
        WHEN "estado":U THEN ASSIGN pFieldValue = RowObject.estado.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice OPERACAO
  Parameters:
               retorna valor dos campos do ¡ndice OPERACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
    DEFINE OUTPUT PARAMETER pitem-pai LIKE reservas.item-pai NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-roteiro LIKE reservas.cod-roteiro NO-UNDO.
    DEFINE OUTPUT PARAMETER pop-codigo LIKE reservas.op-codigo NO-UNDO.
    DEFINE OUTPUT PARAMETER pit-codigo LIKE reservas.it-codigo NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
       RETURN "NOK":U.

    ASSIGN pnr-ord-produ = RowObject.nr-ord-produ.
    ASSIGN pitem-pai = RowObject.item-pai.
    ASSIGN pcod-roteiro = RowObject.cod-roteiro.
    ASSIGN pop-codigo = RowObject.op-codigo.
    ASSIGN pit-codigo = RowObject.it-codigo.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "emite-requis":U THEN ASSIGN pFieldValue = RowObject.emite-requis.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "cons-mrp":U THEN ASSIGN pFieldValue = RowObject.cons-mrp.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:
               recebe nome do campo
               retorna valor do campo
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToCodigo DBOProgram 
PROCEDURE goToCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Procura pelo índice, caso não ache, retorna
        mensagem de erro padrão do  EMS
  Parameters: ipar1:pnr-ord-produ:Ordem Produção
              ipar2:pit-codigo:   Item
 -----------------------------------------------------------------------------*/
    def input parameter  pnr-ord-produ as integer   no-undo.
    def input parameter  pit-codigo    as character no-undo.

    FIND FIRST bfreservas WHERE
        bfreservas.nr-ord-produ = pnr-ord-produ AND
        bfreservas.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreservas THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreservas)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice OPERACAO
  Parameters:
               recebe valor dos campos do ¡ndice OPERACAO
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pitem-pai LIKE reservas.item-pai NO-UNDO.
    DEFINE INPUT PARAMETER pcod-roteiro LIKE reservas.cod-roteiro NO-UNDO.
    DEFINE INPUT PARAMETER pop-codigo LIKE reservas.op-codigo NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo LIKE reservas.it-codigo NO-UNDO.

    FIND FIRST bfreservas WHERE
        bfreservas.nr-ord-produ = pnr-ord-produ AND
        bfreservas.item-pai = pitem-pai AND
        bfreservas.cod-roteiro = pcod-roteiro AND
        bfreservas.op-codigo = pop-codigo AND
        bfreservas.it-codigo = pit-codigo
        NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreservas THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreservas)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRowid DBOProgram 
PROCEDURE goToRowid :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base em seu rowId
  Parameters:
               recebe valor do rowId
               retorna status do processo
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER r-rowId AS ROWID NO-UNDO.    

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
          
    RUN repositionRecord IN THIS-PROCEDURE (INPUT r-rowId).
    
    IF RETURN-VALUE = "NOK":U THEN DO:        
        {utp/ut-table.i movind {&TABLENAME} 1}                              

        {method/svc/errors/inserr.i
            &ErrorNumber="2" 
            &ErrorType="ERROR"
            &ErrorParameters="RETURN-VALUE"}
            
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKeyOrdem DBOProgram 
PROCEDURE goToKeyOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base na ordem, item e estado
  Parameters:  recebe ordem, item e estado
  Notes:
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-ord-produ LIKE reservas.nr-ord-produ NO-UNDO.
    DEFINE INPUT PARAMETER pit-codigo    LIKE reservas.it-codigo    NO-UNDO.
    DEFINE INPUT PARAMETER pestado       LIKE reservas.estado       NO-UNDO.    

    find first bfreservas use-index codigo 
         where bfreservas.nr-ord-produ = pnr-ord-produ
           and bfreservas.it-codigo    = pit-codigo
           and bfreservas.estado       = pestado no-lock no-error.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfreservas THEN
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfreservas)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToOrdTaref DBOProgram 
PROCEDURE linkToOrdTaref :
/*------------------------------------------------------------------------------
  Purpose:     ligacao com a bo de Tarefa da Ordem de Manuten‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
   
   RUN getIntField IN pHandle (INPUT "nr-ord-produ":U, OUTPUT iNrOrdProdu).
   RUN getIntField IN pHandle (INPUT "cd-tarefa",      OUTPUT iCdTarefa).

   RUN setConstraintOrdTaref (INPUT iNrOrdProdu,
                              INPUT iCdTarefa).
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */

    define input parameter i-abertura as integer no-undo.
       case i-abertura:
           when 1 then
              RUN openQueryStatic (input "Main":U). 
              
           when 2 then
              RUN openQueryStatic (input "OrdProdu":U).
           
           when 3 then
              RUN openQueryStatic (input "ItCodigo":U).

           when 4 then
              RUN openQueryStatic (input "OrdProduEst":U).
              
           when 5 then
              RUN openQueryStatic (input "FiltroItCodigo":U).
   
           
       end case.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDetalheReserva DBOProgram 
PROCEDURE openQueryDetalheReserva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query {&QUERYNAME} for each {&TABLENAME} where
               trim({&tablename}.it-codigo) = trim(c-it-codigo-reserva) and
               {&TABLENAME}.estado          = 1                         and
               {&TABLENAME}.cod-refer       = c-refer                   and
              ({&TABLENAME}.quant-orig - {&TABLENAME}.quant-atend) > 0  and
              (if d-data = (today - 1) then
                   {&TABLENAME}.dt-reserva <= d-data
               else 
                   {&TABLENAME}.dt-reserva = d-data) no-lock indexed-reposition.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroItCodigo DBOProgram 
PROCEDURE openQueryFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela reservas dentro de uma 
              faixa de item reserva inicial e final e conforme o número da
              ordem de produção. 
 ------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} where
                                    {&tablename}.it-codigo >= c-inicial and 
                                    {&tablename}.it-codigo <= c-final and
                                    {&TABLENAME}.nr-ord-produ = integer(c-nr-ord-produ)
                                     NO-LOCK INDEXED-REPOSITION.
                                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroOrdProdu DBOProgram 
PROCEDURE openQueryFiltroOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela reservas dentro de uma 
              faixa de numero ordem producao inicial e final. 
 -----------------------------------------------------------------------------*/
open query {&QUERYNAME} for each {&TABLENAME} where
                                 {&TABLENAME}.nr-ord-produ >= int(c-inicial) and 
                                 {&TABLENAME}.nr-ord-produ <= int(c-final)   
                                 NO-LOCK INDEXED-REPOSITION.
                                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryItCodigo DBOProgram 
PROCEDURE openQueryItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela reservas conforme
              o código do item .  
  
------------------------------------------------------------------------------*/
   open query {&QUERYNAME} for each {&TABLENAME} WHERE
                                    {&tablename}.it-codigo = c-it-codigo
                                     NO-LOCK INDEXED-REPOSITION.
                                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     Abertura da query principal do DBO
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QueryName} FOR EACH reservas NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdProdu DBOProgram 
PROCEDURE openQueryOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela reservas dentro de 
              uma faixa de número de ordem de produção. 
   
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME}  where 
                                   {&TABLENAME}.nr-ord-produ = integer (c-nr-ord-produ-aux)
                                    NO-LOCK INDEXED-REPOSITION.

                                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdProduEst DBOProgram 
PROCEDURE openQueryOrdProduEst :
/*------------------------------------------------------------------------------
  Purpose:    Busca conjunto de registros da tabela reservas dentro 
              de uma faixa de número de ordem de produção e o estado
              deve ser igual a 1. 
         
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME}  where 
                                   {&TABLENAME}.nr-ord-produ = integer (c-nr-ord-produ-aux) and
                                   {&TABLENAME}.estado = 1
                                    NO-LOCK INDEXED-REPOSITION.
                                 
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOrdTaref DBOProgram 
PROCEDURE openQueryOrdTaref :
/*------------------------------------------------------------------------------
  Purpose:     abre query por Tarefa da Ordem de Manuten‡Æo
  Parameters:  <none>
  Notes:       
-----------------------------------------------------------------------------*/
    
    open query {&QUERYNAME} for each {&TABLENAME}  where 
                                     {&TABLENAME}.nr-ord-produ = iNrOrdProdu
                                 AND {&TABLENAME}.op-codigo    = iCdTarefa
                                    NO-LOCK INDEXED-REPOSITION.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE quantidadeAlocadaItem DBOProgram 
PROCEDURE quantidadeAlocadaItem :
/*------------------------------------------------------------------------------
  Purpose:    Calcula o saldo da quantidade alocada do item   
  Parameters: ipar1:i-ordem:    Ordem
              ipar2:c-it-codigo:Item reserva
              opar3:de-saldo:   Saldo 
  -----------------------------------------------------------------------------*/
    define input  parameter i-ordem     as integer.
    define input  parameter c-it-codigo as char format "x(16)".
    define output parameter de-saldo    as decimal.
     
    for each {&TABLENAME} fields(nr-ord-produ it-codigo 
                                 quant-orig   quant-atend quant-aloc)
       where {&TABLENAME}.nr-ord-produ = i-ordem
       and   {&tablename}.it-codigo    = c-it-codigo:
        assign de-saldo    = ({&TABLENAME}.quant-orig - {&TABLENAME}.quant-atend - {&TABLENAME}.quant-aloc).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaSomaOrig DBOProgram 
PROCEDURE retornaSomaOrig :
/*------------------------------------------------------------------------------
  Purpose: Este procedimento tem por objetivo retornar a soma original da reserva
           a ser alocada pelo programa de aloca‡Æo (WCP0315).
  Parameters: i-par01: N£mero da Ordem de Produ‡Æo
              o-par01: O valor da Soma Original a ser alocada.
  Notes:
------------------------------------------------------------------------------*/
define input  parameter i-nr-ord-produ as integer no-undo.
define output parameter de-soma-orig   as decimal no-undo.

for each  reservas fields (nr-ord-produ   quant-orig   quant-aloc
                           quant-atend   quant-terc   estado)  
    where reservas.nr-ord-produ = i-nr-ord-produ
      and reservas.estado      = 1 no-lock:
    
    IF reservas.quant-orig  - reservas.quant-aloc - 
       reservas.quant-atend - reservas.quant-terc <= 0 THEN NEXT.
    
    assign de-soma-orig = de-soma-orig
                        + reservas.quant-orig
                        - reservas.quant-aloc
                        - reservas.quant-atend
                        - reservas.quant-terc.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo
              o número da ordem de produção. 
  Parameters: ipar:c-nr-ord-produ: Número Ordem Produção 
     
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    define input parameter c-nr-ord-produ as char no-undo.
        
    run setConstraintOrdProdu (c-nr-ord-produ).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint3 DBOProgram 
PROCEDURE setConstraint3 :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o 
              código do item reserva. 
  Parameters: ipar:p-it-codigo:Item Reserva 
       
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    define input parameter p-it-codigo as char no-undo.
            
    run setConstraintItCodigo (p-it-codigo).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintDetalheReserva DBOProgram 
PROCEDURE setConstraintDetalheReserva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param  c-it-codigo-param as char no-undo.
def input param  c-cod-refer       as char no-undo.
def input param  c-data            as char no-undo.

def var          da-data-param     as date no-undo.

    /* se for igual a anterior da-data-param = ? por causa do no-error */
    assign da-data-param = date(c-data) no-error.

    assign  c-it-codigo-reserva  = c-it-codigo-param
            c-refer              = c-cod-refer
            d-data               = if da-data-param = ?  
                                   then (today - 1)
                                   else date(c-data).

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroItCodigo DBOProgram 
PROCEDURE setConstraintFiltroItCodigo :
/*------------------------------------------------------------------------------
  Purpose:     Seta as variáveis de controle para queries contendo
              o código do item reserva inicial e final e o número
              ordem produção. 
  Parameters: ipar1:pinicial:Item Reserva Inicial
              ipar2:pfinal:Item Reserva Final
              ipar3:pnr-ord-produ:Ordem Produção     
------------------------------------------------------------------------------*/
  def input parameter pinicial      as character no-undo.
  def input parameter pfinal        as character no-undo.
  def input parameter pnr-ord-produ as character no-undo.

  assign c-inicial      = pinicial
         c-final        = pfinal
         c-nr-ord-produ = pnr-ord-produ.
         
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroOrdProdu DBOProgram 
PROCEDURE setConstraintFiltroOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variaveis de controle para queries contendo
              o numero ordem producao inicial e final. 
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter pord-produ-ini     as character no-undo.
  def input parameter pord-produ-fim     as character no-undo.
  

  assign c-inicial      = pord-produ-ini
         c-final        = pord-produ-fim.
         
         
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintItCodigo DBOProgram 
PROCEDURE setConstraintItCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo o 
              código do item reserva. 
  Parameters: ipar:pit-codigo:Item Reserva 
 ------------------------------------------------------------------------------*/
   define input parameter pit-codigo as char no-undo.
 
   assign c-it-codigo = pit-codigo.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdProdu DBOProgram 
PROCEDURE setConstraintOrdProdu :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo
              o número da ordem de produção. 
  Parameters: ipar:pnr-ord-produ: Número Ordem Produção        
------------------------------------------------------------------------------*/
   define input parameter pnr-ord-produ as char no-undo.
 
   assign c-nr-ord-produ-aux = pnr-ord-produ.
   
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOrdTaref DBOProgram 
PROCEDURE setConstraintOrdTaref :
/*------------------------------------------------------------------------------
  Purpose:     Seta constraint por tarefa da ordem de manuten‡Æo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pNrOrdProdu AS INT NO-UNDO.
DEF INPUT PARAM pCdTarefa   AS INT NO-UNDO.

ASSIGN  iNrOrdProdu = pNrOrdProdu
        iCdTarefa   = pCdTarefa.

RETURN "OK":U.              
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRecebeEstadosOrdem DBOProgram 
PROCEDURE setConstraintRecebeEstadosOrdem :
/*------------------------------------------------------------------------------
  Purpose:    Recebe os estados da ordem: nao-iniciadas, liberadas, alocadas, separadas,
               requisitadas, iniciadas, finalizadas, terminadas.
  Parameters: ipar1:p-nao-iniciadas:Não Iniciadas
              ipar2:p-liberadas:    Liberadas
              ipar3:p-alocadas:     Alocadas
              ipar4:p-separadas:    Separadas
              ipar5:p-requisitadas: Requisitadas
              ipar6:p-iniciadas:    Iniciadas
              ipar7:p-finalizadas:  Finalizadas 
              ipar8:p-terminadas:   Terminadas
------------------------------------------------------------------------------*/
  define input parameter p-nao-iniciadas as char no-undo.
  define input parameter p-liberadas     as char no-undo.
  define input parameter p-alocadas      as char no-undo.
  define input parameter p-separadas     as char no-undo.
  define input parameter p-requisitadas  as char no-undo.
  define input parameter p-iniciadas     as char no-undo.
  define input parameter p-finalizadas   as char no-undo.
  define input parameter p-terminadas    as char no-undo.
  
  assign l-nao-iniciadas = if p-nao-iniciadas = "yes" then YES  else NO 
         l-liberadas     = if p-liberadas     = "yes" then YES  else NO
         l-alocadas      = if p-alocadas      = "yes" then YES  else NO
         l-separadas     = if p-separadas     = "yes" then YES  else NO
         l-requisitadas  = if p-requisitadas  = "yes" then YES  else NO
         l-iniciadas     = if p-iniciadas     = "yes" then YES  else NO
         l-finalizadas   = if p-finalizadas   = "yes" then YES  else NO
         l-terminadas    = if p-terminadas    = "yes" then YES  else NO.
         
  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintZoomReservas DBOProgram 
PROCEDURE setConstraintZoomReservas :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variáveis de controle para queries contendo
              o código do item reserva inicial e final e o número
              ordem produção. 
  Parameters: ipar1:p-inicial:Item Reserva Inicial
              ipar2:p-final:Item Reserva Final
              ipar3:p-nr-ord-produ:Ordem Produção         
------------------------------------------------------------------------------*/
/* ------------------------ PROXIES BO 1.1 ----------------------------- */
    
    def input parameter p-inicial      as character no-undo.
    def input parameter p-final        as character no-undo.
    def input parameter p-nr-ord-produ as character no-undo.

        
    run setConstraintFiltroItCodigo (p-inicial,
                                     p-final,
                                     p-nr-ord-produ).
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaEstadoOrdem DBOProgram 
PROCEDURE validaEstadoOrdem :
/*------------------------------------------------------------------------------
  Purpose:    Valida os estados da ordem.  
  Parameters: ipar:r-rowid 
              opar:l-exibe
 ------------------------------------------------------------------------------*/
    /*define input  param r-rowid as rowid                      no-undo.*/
    define input  param p-ord-produ as integer no-undo.
    define output param l-exibe as logical initial yes  no-undo.
  
    define buffer b-reservas for reservas.
    

    /*find b-reservas where rowid(b-reservas) = r-rowid no-lock no-error.*/
                  
    find first ord-prod where
               ord-prod.nr-ord-produ = p-ord-produ and /*b-reservas.nr-ord-produ*/
             ((ord-prod.estado = 1 and l-nao-iniciadas)  or
              (ord-prod.estado = 2 and l-liberadas    )  or   
              (ord-prod.estado = 3 and l-alocadas     )  or
              (ord-prod.estado = 4 and l-separadas    )  or 
              (ord-prod.estado = 5 and l-requisitadas )  or
              (ord-prod.estado = 6 and l-iniciadas    )  or
              (ord-prod.estado = 7 and l-finalizadas  )  or
              (ord-prod.estado = 8 and l-terminadas   )) NO-LOCK no-error.
    if  not avail ord-prod then
        assign l-exibe = no.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   
    if not avail param-global then
	    FIND FIRST param-global NO-LOCK NO-ERROR.
   
    for first ord-prod
	    where ord-prod.nr-ord-produ = rowObject.nr-ord-produ no-lock:
    end.

    if ord-prod.nr-req-sum <> 0 then do:
	    if not valid-handle (h-cpapi018) then
	        run cpp/cpapi018.p persistent set h-cpapi018 (input        table tt-dados,
											      	      input        table tt-ord-prod-2,
														  input-output table tt-req-sum,
														  input-output table tt-erro,
														  input        yes).

	    run pi-elimina-req-sum-reserva in h-cpapi018 (input rowid(reservas)).
    end.
    
    if param-global.modulo-pl = yes or param-global.modulo-pi = yes
    then do:
	    run cdp/cd7000.p (input 0,
	 					  input rowObject.it-codigo,
	 					  input ord-prod.cod-estabel). /* usado p/ planejamento */
	    run cdp/cd7000.p (input 0,
	 					  input ord-prod.it-codigo,
	 					  input ord-prod.cod-estabel). /* usado p/ planejamento */
    end.
    
    /*-- Aloca‡Æo de Reservas --*/
    if not valid-handle (h-cpapi013) then 
	    run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
	 												  input        table tt-deposito,
	 												  input-output table tt-erro,
	 												  input        yes).
    
    run pi-desaloca-reserva in h-cpapi013 (input rowid(reservas)). /* Elimina aloca‡Æo */

    ASSIGN iNrOrdProdu = reservas.nr-ord-produ.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida temptable RowObject
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/
    /*--- Verifica ocorrˆncia de erros ---*/
	
	IF pType = "DELETE" THEN DO:
	
		run verificaOrdem (input rowObject.nr-ord-produ).
	
		if rowObject.quant-atend > 0  then do: 
		
			{method/svc/errors/inserr.i
				&ErrorNumber="1757" /*Reserva possui quantidade atendida para a ordem.*/
				&ErrorType="EMS"
				&ErrorSubType="ERROR"
			}                 
	    end.
	END.	
	
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaOrdem DBOProgram 
PROCEDURE verificaOrdem :
/*------------------------------------------------------------------------------
  Purpose:     Este procedimento tem por finalidade verificar se a Reserva
               da Ordem que o usu rio deseja alterar/modificar/eliminar
               pertence as Ordens de Manutenção Industrial ou Nao e caso 
               esta Ordem perten‡a as de Ordem de Produção, verificar se
               ela não se encontra no estado de Finalizada (7) ou Terminada (8).
  Parameters:  ipar: i-nr-ord-produ:Ordem Produção       
------------------------------------------------------------------------------*/
define input parameter i-nr-ord-produ as integer no-undo.
define variable c-return       as character no-undo.

    RUN inbo/boin270.p persistent set h-boin270.
	RUN findNumero in h-boin270 (input i-nr-ord-produ, output c-return).
	
	if c-return = " " then do:
		/* Inicio -- Projeto Internacional */
		DEFINE VARIABLE c-lbl-liter-ordem-produoo AS CHARACTER NO-UNDO.
		{utp/ut-liter.i "Ordem_Produ‡Æo" *}
		ASSIGN c-lbl-liter-ordem-produoo = TRIM(RETURN-VALUE).
		{method/svc/errors/inserr.i
				&ErrorNumber="663" /*Este programa nÆo trata Ordens de Manuten‡Æo Industrial*/
				&ErrorType="EMS"
				&ErrorParameters="c-lbl-liter-ordem-produoo"}                   
	end.
	
    delete procedure h-boin270.

    RUN inbo/boin271.p persistent set h-boin271.
	RUN findCodigo in h-boin271 (input i-nr-ord-produ, output c-return).

	if c-return = " " then do:

		RUN getCurrent in h-boin271 (output table tt-ord-prod).
		
		FIND FIRST tt-ord-prod NO-ERROR.
		IF AVAIL tt-ord-prod THEN DO:
			if tt-ord-prod.estado = 7 or tt-ord-prod.estado = 8 then do:
					/* Inicio -- Projeto Internacional */
					{utp/ut-table.i movind ord-prod 1} /* Busca o label da tabela */
					{method/svc/errors/inserr.i
						&ErrorNumber="1663" /*O Estado da Ordem nÆo pode estar como Terminada ou Finalizada*/
						&ErrorType="EMS"
						&ErrorParameters=TRIM(RETURN-VALUE)}
			end.
		END.
	end. 

    delete procedure h-boin271.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
