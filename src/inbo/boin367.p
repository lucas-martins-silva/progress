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
{include/i-prgvrs.i BOIN367 2.00.00.095 } /*** "010095" 16/09/2025 16:13:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin367 MUT}
&ENDIF

/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) Ç um programa PROGRESS 
                 que contÇm a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName BOIN367
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName rat-lote
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS Main,OfDocumEst,OfItemDocEst

&GLOBAL-DEFINE excludeFrameDefinition YES

/*--- Include com definiá∆o da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idàntico ao nome do DBO mas com 
      extens∆o .i ---*/
{inbo/boin367.i RowObject}
{inbo/boin367.i tt-rat-lote-fda}

{cdp/cdcfgman.i}
{cdp/cdcfgmat.i}

/*--- Include com definiá∆o da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de alteraá∆o da definiá∆o da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a definiá∆o 
      manual da query ---*/
{method/dboqry.i}
{include/i-epc200.i BOIN367} /* Definicao tt-EPC */

/*--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

def buffer b-rat-lote for rat-lote.

/* local variables definitions */
DEFINE VARIABLE c-it-codigo    LIKE RowObject.it-codigo    NO-UNDO.
DEFINE VARIABLE i-cod-emitente LIKE RowObject.cod-emitente NO-UNDO.
DEFINE VARIABLE c-serie-docto  LIKE RowObject.serie-docto  NO-UNDO.
DEFINE VARIABLE c-nro-docto    LIKE RowObject.nro-docto    NO-UNDO.
DEFINE VARIABLE c-nat-operacao LIKE RowObject.nat-operacao NO-UNDO.
DEFINE VARIABLE c-cod-refer    LIKE RowObject.cod-refer    NO-UNDO.
DEFINE VARIABLE i-sequencia    LIKE RowObject.sequencia    NO-UNDO.

DEFINE VARIABLE l-re0708              AS LOGICAL NO-UNDO.
DEFINE VARIABLE i-cont-prog           AS INTEGER NO-UNDO.
DEFINE VARIABLE h-cdapi034            AS HANDLE  NO-UNDO.
DEFINE VARIABLE i-cod-regra-utilizada AS INTEGER NO-UNDO.

def var de-qtde-item       like item-doc-est.quantidade    no-undo.
def var l-baixa-estoq      like item-doc-est.baixa-ce      no-undo.
def var c-tipo             as char                         no-undo.
def var h-boin060          as handle                       no-undo.
def var i-indice-cq        as int                          no-undo.
DEF VAR i-ind              AS INT                          NO-UNDO. 
DEF VAR i-tp-skip-lote-aux AS INT                          NO-UNDO.
DEF VAR c-lb-msg           AS CHAR                         NO-UNDO.
DEF VAR l-executa-engine   AS LOG INIT NO                  NO-UNDO.

{utp/ut-glob.i}

{cdp/cdcfgman.i}

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  DEF VAR l-lote-avancado AS LOG NO-UNDO.
  {cep/ceapi030.i}
  {cdp/cd0666.i}
  {fch/fchmat/fchmatqualitycontrolsimulation.i ttCQSimulationVO}
  ASSIGN l-lote-avancado = CAN-FIND(FIRST funcao 
							        WHERE funcao.cd-funcao = "lote-avancado" 
							        AND   funcao.ativo     = TRUE).
&endif


DEF TEMP-TABLE tt-rat-lote NO-UNDO LIKE rat-lote.

DEF TEMP-TABLE tt-saldo-lote NO-UNDO                      
        FIELD it-codigo    LIKE      item-doc-est.it-codigo   
        FIELD cod-localiz  LIKE      item-doc-est.cod-localiz
        FIELD cod-depos    LIKE      item-doc-est.cod-depos
        FIELD lote         LIKE      item-doc-est.lote        
        FIELD quantidade   LIKE      item-doc-est.quantidade. 

DEFINE TEMP-TABLE tt-variavel NO-UNDO
    FIELD cod-var-oper   AS CHARACTER FORMAT "x(16)"
    FIELD valor-variavel AS CHARACTER FORMAT "x(60)".

DEFINE TEMP-TABLE tt-retorno NO-UNDO
    FIELD valor-retorno AS CHARACTER FORMAT "x(60)"
    FIELD campo-retorno AS CHARACTER FORMAT "x(60)"
    FIELD perc-rateio   AS DECIMAL FORMAT ">>9,99".

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
         HEIGHT             = 2
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


/* ***************************  Main Block  *************************** */
    for first param-global 
        fields ( modulo-cq ) no-lock.
    end.
    
    for first param-estoq 
        fields ( char-2 ) no-lock.
    end.
    
    run findParamCQ.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE znv-insp DBOProgram 
PROCEDURE atualizanv-insp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Atualiza o n°vel de innspeá∆o referente ao controle de qualidade
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pItCodigo    like item.it-codigo         NO-UNDO.
DEFINE INPUT PARAMETER pCodEmitente like docum-est.cod-emitente NO-UNDO.
DEFINE INPUT PARAMETER pCodestabel  like docum-est.cod-estabel  NO-UNDO.

if  avail param-cq
    and param-cq.tipo-cq = 3 then do:

    find first item
        where item.it-codigo = pItCodigo no-lock no-error.

    find first item-fornec-estab
        where  item-fornec-estab.it-codigo    = pItCodigo   
        and    item-fornec-estab.cod-emitente = pCodEmitente
        and    item-fornec-estab.cod-estabel  = pCodestabel exclusive-lock no-error.

    if avail item-fornec-estab 
    and  item-fornec-estab.tp-inspecao > 3 then do:
        if item-fornec-estab.niv-inspecao > 0 then do:
            assign item-fornec-estab.niv-inspecao =  item-fornec-estab.niv-inspecao - 1.
        end.
        else do:
            ASSIGN i-ind = item-fornec-estab.tp-inspecao - 3.
			&if '{&bf_lote_avancado_liberado}' = 'yes' &then
				IF l-lote-avancado THEN DO:
					FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = pCodEmitente NO-LOCK NO-ERROR.
					IF AVAIL fda-param-inspec-fornec THEN DO:
						CASE item.criticidade:
							WHEN 1 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                END CASE.
                                
                            END.
							WHEN 2 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                END CASE.
                            end. 
							WHEN 3 THEN DO:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                END CASE.
                            END.
							OTHERWISE   assign i-indice-cq = 0.
						END CASE.
					END.
					ELSE DO:
						/*caso nao existir registro, procura na tabela fda-param-inspec*/
						FIND emitente WHERE emitente.cod-emitente = pCodEmitente NO-LOCK NO-ERROR.
						FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
						IF AVAIL fda-param-inspec THEN DO:
							CASE item.criticidade:
								WHEN 1 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                    END CASE.
                                END.
    							WHEN 2 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                    END CASE.
                                end. 
    							WHEN 3 THEN DO:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                    END CASE.
                                END.
								OTHERWISE   assign i-indice-cq = 0.
							END CASE.
						END.
						ELSE DO:
							CASE item.criticidade:
								WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
								WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
								WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
								OTHERWISE   assign i-indice-cq = 0.
							END CASE.
						END.
					END.
				END.
				ELSE DO:
					CASE item.criticidade:
						WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
						WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
						WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
						OTHERWISE   assign i-indice-cq = 0.
					END CASE.
				END.
			&ELSE
				CASE item.criticidade:
					WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
					WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
					WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
					OTHERWISE   assign i-indice-cq = 0.
				END CASE.
			&ENDIF

            assign item-fornec-estab.niv-inspecao =  i-indice-cq.
        end.
    end.

    if not avail item-fornec-estab  then do:
        find first item-fornec
            where  item-fornec.it-codigo    = pItCodigo   
            and    item-fornec.cod-emitente = pCodEmitente exclusive-lock no-error.
        if avail item-fornec
        and  item-fornec.tp-inspecao > 3 then do:
            ASSIGN i-ind = item-fornec.tp-inspecao - 3.
        
            if avail item-fornec then
                if item-fornec.niv-inspecao > 0 then
                    assign item-fornec.niv-inspecao =  item-fornec.niv-inspecao - 1.
                else do:
					&if '{&bf_lote_avancado_liberado}' = 'yes' &then
						IF l-lote-avancado THEN DO:
							FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = pCodEmitente NO-LOCK NO-ERROR.
							/*procura na tabela fda-param-inspec-fornec */
							IF AVAIL fda-param-inspec-fornec THEN DO:
								CASE item.criticidade:
									WHEN 1 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                        END CASE.
                                        
                                    END.
        							WHEN 2 THEN do:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                        END CASE.
                                    end. 
        							WHEN 3 THEN DO:
                                        CASE i-ind:
                                            WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                            WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                            WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                        END CASE.
                                    END.
									OTHERWISE   assign i-indice-cq = 0.
								END CASE.
							END.
							ELSE DO:
								/*caso nao existir registro, procura na tabela fda-param-inspec*/
								FIND emitente WHERE emitente.cod-emitente = pCodEmitente NO-LOCK NO-ERROR.
								FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
								IF AVAIL fda-param-inspec THEN DO:
									CASE item.criticidade:
										WHEN 1 THEN do:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                            END CASE.
                                        END.
            							WHEN 2 THEN do:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                            END CASE.
                                        end. 
            							WHEN 3 THEN DO:
                                            CASE i-ind:
                                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                            END CASE.
                                        END.
										OTHERWISE   assign i-indice-cq = 0.
									END CASE.
								END.
								ELSE DO:
									CASE item.criticidade:
										WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
										WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
										WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
										OTHERWISE   assign i-indice-cq = 0.
									END CASE.
								END.
							END.	
						END.
						/*Caso a funcao nao esteja ativada*/
						ELSE DO:
							CASE item.criticidade:
								WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
								WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
								WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
								OTHERWISE   assign i-indice-cq = 0.
							END CASE.
						END.
					/*Caso preprocessador estiver abaixo da 2.08 vai ser apenas executado este CASE*/
					&ELSE
						CASE item.criticidade:
							WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
							WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
							WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
							OTHERWISE   assign i-indice-cq = 0.
						END CASE.
					&ENDIF

                    assign item-fornec.niv-inspecao =  i-indice-cq.
                end.
        end.
    end.

end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizanNvInspbyNF DBOProgram 
PROCEDURE atualizanNvInspbyNF :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Atualiza o n°vel de innspeá∆o referente ao controle de qualidade
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pCodEmitente like docum-est.cod-emitente    NO-UNDO.
DEFINE INPUT PARAMETER pNroDocto    like item-doc-est.nro-docto    NO-UNDO.
DEFINE INPUT PARAMETER pNatOperacao like item-doc-est.nat-operacao NO-UNDO.
DEFINE INPUT PARAMETER pSerieDocto  like item-doc-est.serie-docto  NO-UNDO.
DEFINE INPUT PARAMETER pCodEstabel  like docum-est.cod-estabel     NO-UNDO.



for each item-doc-est fields (serie-docto nro-docto nat-operacao cod-emitente sequencia it-codigo)
    where item-doc-est.serie-docto  = pSerieDocto
    and   item-doc-est.nro-docto    = pNroDocto
    and   item-doc-est.nat-operacao = pNatOperacao
    and   item-doc-est.cod-emitente = pCodEmitente no-lock.

    for each rat-lote 
        where rat-lote.cod-emitente = item-doc-est.cod-emitente
         and  rat-lote.nro-docto    = item-doc-est.nro-docto   
         and  rat-lote.nat-operacao = item-doc-est.nat-operacao
         and  rat-lote.serie-docto  = item-doc-est.serie-docto 
         and  rat-lote.sequencia    = item-doc-est.sequencia  no-lock:
    
         run atualizanv-insp (input item-doc-est.it-codigo,
                              input item-doc-est.cod-emitente,
                              input pCodEstabel).
    end.
end.

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
    if  valid-handle (h-boin060) then DO:
        delete procedure h-boin060.
        assign h-boin060 = ?.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields DBOProgram 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piItem             like rat-lote.it-codigo  no-undo.
    def output param piHabilitaLocaliz  as log                   no-undo.
    def output param piHabilitaLote     as log                   no-undo.
    def output param piHabilitaValidade as log                   no-undo.
    def output param piHabilitaQtde     as log                   no-undo.
    def output param piHabilitaperppm   as log                   no-undo.

    run findItem ( piItem ).
    
    if  return-value = "NOK":U then
        return "NOK":U.
        
    IF AVAIL docum-est THEN
        FOR FIRST item-uni-estab
            WHERE item-uni-estab.it-codigo   = item.it-codigo
            AND   item-uni-estab.cod-estabel = docum-est.cod-estabel NO-LOCK.
        END.
    
    IF NOT AVAIL docum-est OR 
       NOT AVAIL item-uni-estab THEN
        RETURN "NOK":U.

    assign piHabilitaLocaliz  = not item-uni-estab.loc-unica
           piHabilitaLote     = item.tipo-con-est <> 1
           piHabilitaValidade = can-do("3,4",string(item.tipo-con-est))
           piHabilitaQtde     = item.tipo-con-est <> 2.

    &IF DEFINED(bf_man_per_ppm) &THEN 
      ASSIGN pihabilitaperppm = item.tipo-formula = 2 or item.tipo-formula = 3.
    &endif

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDeposito DBOProgram 
PROCEDURE findDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodDepos   like deposito.cod-depos no-undo.
    
    if  not avail deposito
    or  deposito.cod-depos <> piCodDepos then 
    
        for first deposito fields ( cod-depos nome )
            where deposito.cod-depos = piCodDepos no-lock.
        end.
        
    if  not avail deposito then do:

        ASSIGN l-re0708 = NO.
        DO  i-cont-prog = 1 TO 30:
            IF  PROGRAM-NAME(i-cont-prog) MATCHES "*re0708*" THEN DO:
                ASSIGN l-re0708 = YES.
                LEAVE.
            END.
        END.

        IF l-re0708 AND AVAIL item-doc-est THEN DO:
            {utp/ut-liter.i "Dep¢sito_da_sequencia_" *}
            ASSIGN c-lb-msg = RETURN-VALUE + trim(substring(item-doc-est.char-2,832,5)).
        END.
        ELSE DO:
            {utp/ut-liter.i "Dep¢sito" *}
            ASSIGN c-lb-msg = RETURN-VALUE.
        END.

        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findDocumento DBOProgram 
PROCEDURE findDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param piCodEmitente  like docum-est.cod-emitente  no-undo.
    def input param piSerieDocto   like docum-est.serie-docto   no-undo.
    def input param piNroDocto     like docum-est.nro-docto     no-undo.
    def input param piNatOperacao  like docum-est.nat-operacao  no-undo.

    if  not avail docum-est 
    or  docum-est.cod-emitente <> piCodEmitente
    or  docum-est.serie-docto  <> piSerieDocto
    or  docum-est.nro-docto    <> piNroDocto
    or  docum-est.nat-operacao <> piNatOperacao then 
        
        for first docum-est
            where docum-est.cod-emitente = piCodEmitente
              and docum-est.serie-docto  = piSerieDocto
              and docum-est.nro-docto    = piNroDocto
              and docum-est.nat-operacao = piNatOperacao no-lock.
        end.
    
    if  not avail docum-est then do:
        {utp/ut-liter.i "Documento" *}
        ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItem DBOProgram 
PROCEDURE findItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem   like item-doc-est.it-codigo no-undo.
    
    if  not avail item
    or  item.it-codigo <> piItem then 
    
        for first item
            where item.it-codigo = piItem no-lock.
        end.
        
    if  not avail item then do:
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemUniEstab DBOProgram 
PROCEDURE findItemUniEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piItem like item-doc-est.it-codigo no-undo.
    DEF INPUT PARAM pestab LIKE docum-est.cod-estabel NO-UNDO. 

    
    if  not avail item-uni-estab
    or  item-uni-estab.it-codigo <> piItem then 
    
        for first item-uni-estab
            fields ( it-codigo     lim-var-valor
                cod-estabel   var-val-re-maior
                var-qtd-re    lim-var-qtd
                deposito-pad  cod-localiz
                loc-unica     contr-qualid)         

            where item-uni-estab.it-codigo   = piItem 
            AND   item-uni-estab.cod-estabel = pestab no-lock.
        end.
        
    if  not avail item-uni-estab then do:
        {utp/ut-liter.i "Item" *}
        ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findItemDocumento DBOProgram 
PROCEDURE findItemDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente like item-doc-est.cod-emitente no-undo.
    def input param piSerieDocto  like item-doc-est.serie-docto  no-undo.
    def input param piNroDocto    like item-doc-est.nro-docto    no-undo.
    def input param piNatOperacao like item-doc-est.nat-operacao no-undo.
    def input param piSequencia   like item-doc-est.sequencia    no-undo.
    
    if  not avail item-doc-est 
    or  item-doc-est.serie-docto  <> piSerieDocto
    or  item-doc-est.nro-docto    <> piNroDocto
    or  item-doc-est.nat-operacao <> piNatOperacao
    or  item-doc-est.cod-emitente <> piCodEmitente
    or  item-doc-est.sequencia    <> piSequencia then 
    
        for first item-doc-est
            where item-doc-est.serie-docto  = piSerieDocto
              and item-doc-est.nro-docto    = piNroDocto
              and item-doc-est.nat-operacao = piNatOperacao
              and item-doc-est.cod-emitente = piCodEmitente 
              and item-doc-est.sequencia    = piSequencia no-lock.
        end.

    if  not avail item-doc-est then do:
        {utp/ut-liter.i "Item_do_Documento" *}
        ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.        


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLocalizacao DBOProgram 
PROCEDURE findLocalizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piEstab   like docum-est.cod-estabel    no-undo.
    def input param piLocaliz like item-doc-est.cod-localiz no-undo.
    def input param piDepos   like item-doc-est.cod-depos   no-undo.
    
    if  not avail localizacao
    or  localizacao.cod-estabel <> piEstab
    or  localizacao.cod-localiz <> piLocaliz 
    or  localizacao.cod-depos   <> piDepos then 
    
        for first localizacao
            fields ( cod-estabel cod-localiz cod-depos )
            where localizacao.cod-estabel = piEstab
              and localizacao.cod-localiz = piLocaliz
              and localizacao.cod-depos   = piDepos  no-lock.
        end.
        
    if  not avail localizacao then do:

        ASSIGN l-re0708 = NO.
        DO  i-cont-prog = 1 TO 30:
            IF  PROGRAM-NAME(i-cont-prog) MATCHES "*re0708*" THEN DO:
                ASSIGN l-re0708 = YES.
                LEAVE.
            END.
        END.

        IF l-re0708 AND AVAIL item-doc-est THEN DO:
            {utp/ut-liter.i "Localizaá∆o_da_sequencia_" *}
            ASSIGN c-lb-msg = RETURN-VALUE + trim(substring(item-doc-est.char-2,832,5)).
        END.
        ELSE DO:
            {utp/ut-liter.i "Localizaá∆o" *}
            ASSIGN c-lb-msg = RETURN-VALUE.
        END.

        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNatureza DBOProgram 
PROCEDURE findNatureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piNatOperacao   like docum-est.nat-operacao no-undo.
    
    if  not avail natur-oper
    or  natur-oper.nat-operacao <> piNatOperacao then 
    
        for first natur-oper
            fields ( nat-operacao tipo terceiros 
                     tp-oper-terc transf )            
            where natur-oper.nat-operacao = piNatOperacao no-lock.
        end.
        
    if  not avail natur-oper then do:
        {utp/ut-liter.i "Natureza_de_Operaá∆o" *}
        ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                            &ErrorNumber="2"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters="c-lb-msg"}
        RETURN "NOK":U.
    end.
    else         
        RETURN "OK":U.     
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findParamCQ DBOProgram 
PROCEDURE findParamCQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for first param-cq 
        fields ( tipo-cq tp-skip-lot ins-pref-x
                 ins-pref-y ins-pref-z ) no-lock.
    end.
    
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
        WHEN "cod-depos":U THEN ASSIGN pFieldValue = RowObject.cod-depos.
        WHEN "cod-localiz":U THEN ASSIGN pFieldValue = RowObject.cod-localiz.
        WHEN "it-codigo":U THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "lote":U THEN ASSIGN pFieldValue = RowObject.lote.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nro-docto":U THEN ASSIGN pFieldValue = RowObject.nro-docto.
        WHEN "serie-docto":U THEN ASSIGN pFieldValue = RowObject.serie-docto.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCodBarras DBOProgram 
PROCEDURE getCodBarras :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto       LIKE   rat-lote.serie-docto     NO-UNDO.  
    DEFINE INPUT PARAMETER pnro-docto         LIKE   rat-lote.nro-docto       NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente      LIKE   rat-lote.cod-emitente    NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao      LIKE   rat-lote.nat-operacao    NO-UNDO.
    DEFINE INPUT PARAMETER psequencia         LIKE   rat-lote.sequencia       NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-barras        AS     CHAR FORMAT "X(50)"      NO-UNDO.
    DEFINE OUTPUT PARAMETER plotefabr          LIKE   rat-lote.lote            NO-UNDO.
    DEFINE OUTPUT PARAMETER pdt-vali-lote-fabr LIKE   rat-lote.dt-vali-lote    NO-UNDO.
    
    FIND FIRST bfrat-lote 
         WHERE bfrat-lote.serie-docto  = pserie-docto 
         AND   bfrat-lote.nro-docto    = pnro-docto 
         AND   bfrat-lote.cod-emitente = pcod-emitente 
         AND   bfrat-lote.nat-operacao = pnat-operacao 
         AND   bfrat-lote.sequencia    = psequencia NO-LOCK NO-ERROR.
    IF AVAIL bfrat-lote THEN DO:
       &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
           &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
               ASSIGN  pcod-barras        = bfrat-lote.cod-barras
                       plotefabr          = bfrat-lote.cod-lote-fabrican 
                       pdt-vali-lote-fabr = bfrat-lote.dat-valid-lote-fabrican. 
           &ELSE
                ASSIGN  pcod-barras        = SUBSTRING(bfrat-lote.char-2,1,50)
                        plotefabr          = SUBSTRING(bfrat-lote.char-2,51,10)
                        pdt-vali-lote-fabr = bfrat-lote.data-2.
           &ENDIF
       &ENDIF
    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getConfigurado DBOProgram 
PROCEDURE getConfigurado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piItem         like rat-lote.it-codigo  no-undo.
    def input  param piBaixaEstoq   as log                   no-undo.
    def output param piConfigurado  as log                   no-undo.
     
    run findItem ( piItem ).

    if  return-value = "NOK":U then
        return "NOK":U.
    
    assign piConfigurado =   not piBaixaEstoq          /* Nao Atualiza Estoque */
                         and docum-est.esp-docto = 20  /* Devolucao Cliente */
                         and (   item.politica = 5     /* Configurado */
                              or item.politica = 6 ).  /* Composto */

    return "OK":U.
 
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "dt-vali-lote":U THEN ASSIGN pFieldValue = RowObject.dt-vali-lote.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "quantidade":U THEN ASSIGN pFieldValue = RowObject.quantidade.
        WHEN "vl-movto":U THEN ASSIGN pFieldValue = RowObject.vl-movto.
        &IF DEFINED(bf_man_per_ppm) &THEN 
            WHEN "per-ppm":U THEN ASSIGN pFieldValue = RowObject.per-ppm.
        &ENDIF
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDepositoCQ DBOProgram 
PROCEDURE getDepositoCQ :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piDepositoCQ  as log init yes  no-undo.

    if  avail param-cq
    and param-cq.tipo-cq = 3 then do:
        
        &if "{&bf_mat_versao_ems}" >= "2.062" &then
            RUN pi-calc-indice (output piDepositoCQ).
        &else 
            IF CAN-FIND(FIRST funcao
                        WHERE funcao.cd-funcao = "spp-cq-itfornest":U
                        AND   funcao.ativo     = YES) THEN DO:
                RUN pi-calc-indice (output piDepositoCQ).
            END.
        &endif

            
        for first item-fornec fields ( it-codigo   cod-emitente 
                                       tp-inspecao niv-inspecao )
            where item-fornec.it-codigo = item.it-codigo 
            and   item-fornec.cod-emitente = docum-est.cod-emitente exclusive-lock.
        end.
        if not avail item-fornec-estab and avail item-fornec
        and item-fornec.tp-inspecao > 3 then do:
            ASSIGN i-ind = item-fornec.tp-inspecao - 3.
			&if '{&bf_lote_avancado_liberado}' = 'yes' &then
				IF l-lote-avancado THEN DO:
					FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = docum-est.cod-emitente NO-LOCK NO-ERROR .		
					IF AVAIL fda-param-inspec-fornec THEN DO:
						CASE item.criticidade:
							WHEN 1 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                                END CASE.
                                
                            END.
							WHEN 2 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                                END CASE.
                            end. 
							WHEN 3 THEN DO:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                                END CASE.
                            END.
							OTHERWISE   assign i-indice-cq = 0.
						END CASE.
						ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
					END.
					ELSE DO:
						FIND emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
						FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
						IF AVAIL fda-param-inspec THEN DO:
							CASE item.criticidade:
								WHEN 1 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                    END CASE.
                                END.
    							WHEN 2 THEN do:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                    END CASE.
                                end. 
    							WHEN 3 THEN DO:
                                    CASE i-ind:
                                        WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                        WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                        WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                    END CASE.
                                END.
								OTHERWISE   assign i-indice-cq = 0.
							END CASE.
							ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
						END.
						ELSE DO:
							CASE item.criticidade:
								WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
								WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
								WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
								OTHERWISE   assign i-indice-cq = 0.
							END CASE.
							ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
						END.
					END.
				END.
				ELSE DO:
					CASE item.criticidade:
						WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
						WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
						WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
						OTHERWISE   assign i-indice-cq = 0.
					END CASE.
					ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
				END.
			&ELSE
				CASE item.criticidade:
					WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec.tp-inspecao - 3].
					WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec.tp-inspecao - 3].
					WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec.tp-inspecao - 3].
					OTHERWISE   assign i-indice-cq = 0.
				END CASE.
				ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
			&ENDIF
			if  i-tp-skip-lote-aux = 1 then
				assign piDepositoCQ = ( random(0,100) <= i-indice-cq ).
			else do:
				 assign piDepositoCQ = no.
				 
				 if  i-indice-cq <= item-fornec.niv-inspecao then 
					 assign piDepositoCQ             = yes
							item-fornec.niv-inspecao = 0.
			end.

			if not piDepositoCQ then 
				assign item-fornec.niv-inspecao = item-fornec.niv-inspecao + 1.
        end.
        &if "{&bf_mat_versao_ems}" < "2.062" &then
        if CAN-FIND(FIRST funcao
                    WHERE funcao.cd-funcao = "spp-cq-itfornest"
                    AND   funcao.ativo     = YES) then
        &endif
        do:
            if avail ITEM-FORNEC-ESTAB then do:
                if ITEM-FORNEC-ESTAB.tp-inspecao <= 3 then
                    assign piDepositoCQ = yes.
            end.
            else 
            if avail ITEM-FORNEC then do:
                if ITEM-FORNEC.tp-inspecao <= 3 then
                    assign piDepositoCQ = yes.                
            end.
            else assign piDepositoCQ = yes.
        end.
        &if "{&bf_mat_versao_ems}" < "2.062" &then
        else do: /* IF CAN-FIND FUNCAO */
            if avail ITEM-FORNEC then do:
                if ITEM-FORNEC.tp-inspecao <= 3 then
                    assign piDepositoCQ = yes.                
            end.           
            else assign piDepositoCQ = yes.
        end.
        &endif
        if avail item-fornec then
            release item-fornec.
    END.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescDeposito DBOProgram 
PROCEDURE getDescDeposito :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param piCodDepos   like deposito.cod-depos  no-undo.
    def output param piDescDepos  like deposito.nome       no-undo.
    
    run findDeposito ( piCodDepos ).
    
    assign piDescDepos = if  return-value = "OK":U
                         then deposito.nome
                         else " ".

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFieldsItem DBOProgram 
PROCEDURE getFieldsItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piBaixaEstoq like item-doc-est.baixa-ce    no-undo.
    def input param piQtdeItem   like item-doc-est.quantidade  no-undo.
    
    assign l-baixa-estoq = piBaixaEstoq
           de-qtde-item  = piQtdeItem.

    return "OK":U.
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInitialValues DBOProgram 
PROCEDURE getInitialValues :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
    def input  param piItem         like item-doc-est.it-codigo     no-undo.
    def input  param piNumeroOrdem  like item-doc-est.numero-ordem  no-undo.
    def output param piCodDepos     like item-doc-est.cod-depos     no-undo.
    def output param piCodLocaliz   like item-doc-est.cod-localiz   no-undo.
    def output param piQuantidade   like item-doc-est.quantidade    no-undo.
       
    def var l-deposito-cq           as log                          no-undo.

    run findItem ( piItem ).
    
    if  return-value = "NOK":U then
        return "NOK":U.

    for first item-uni-estab
        fields (it-codigo cod-estabel deposito-pad cod-localiz contr-qualid)
        where item-uni-estab.it-codigo   = item.it-codigo
        and   item-uni-estab.cod-estabel = estabelec.cod-estabel no-lock.
    end.

    if  natur-oper.tipo = 1
    and not natur-oper.terceiros 
    or  (    natur-oper.tp-oper-terc <> 1
         and natur-oper.tp-oper-terc <> 2 ) then do:

        if  param-global.modulo-cq       /* Possui modulo CQ */
        and param-cq.tipo-cq > 1         /* CQ Total */
        and not natur-oper.transf        /* Nao e Transferencia */
        and (avail item-uni-estab and item-uni-estab.contr-qualid) /* Item possui CQ */
        and item.it-codigo <> " " then   /* Item deve ser codificado */ 
            run getDepositoCQ ( output l-deposito-cq ).
     
        if  piNumeroOrdem <> 0 then
            for first ordem-compra fields ( numero-ordem dep-almoxar )
                where ordem-compra.numero-ordem = piNumeroOrdem no-lock.
            end.

            assign piCodDepos   = if  l-deposito-cq
                                  then estabelec.deposito-cq
                                  else
                                      if  avail ordem-compra
                                      then ordem-compra.dep-almoxar
                                      else if  avail item-uni-estab
                                           then item-uni-estab.deposito-pad
                                           else item.deposito-pad
                                      
                   piCodLocaliz = if  avail item-uni-estab
                                  then item-uni-estab.cod-localiz 
                                  else item.cod-localiz
                   piQuantidade = if  item.tipo-con-est = 2
                                  then 1
                                  else 0.
    end.    
    else do: 
    assign piCodDepos   = if  avail ordem-compra
                          then ordem-compra.dep-almoxar
                          else if  avail item-uni-estab
                               then item-uni-estab.deposito-pad
                               else item.deposito-pad

           piCodLocaliz = if  avail item-uni-estab
                          then item-uni-estab.cod-localiz 
                          else item.cod-localiz.
        
           piQuantidade = if  item.tipo-con-est = 2
                          then 1
                          else 0.
    end.
    
    return "OK":U.
    
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-emitente":U THEN ASSIGN pFieldValue = RowObject.cod-emitente.
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "nr-ficha":U THEN ASSIGN pFieldValue = RowObject.nr-ficha.
        WHEN "sequencia":U THEN ASSIGN pFieldValue = RowObject.sequencia.
        WHEN "tipo-nota":U THEN ASSIGN pFieldValue = RowObject.tipo-nota.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getItensWMS DBOProgram 
PROCEDURE getItensWMS :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER  p-nro-docto  LIKE doc-fisico.nro-docto   NO-UNDO.
    DEFINE INPUT PARAMETER  p-serie      LIKE doc-fisico.serie       NO-UNDO.
    DEFINE INPUT PARAMETER  p-emitente   LIKE doc-fisico.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER  p-tipo-nota  LIKE doc-fisico.tipo-nota    NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-rat-lote.  
    
    FIND FIRST doc-fisico NO-LOCK
        WHERE doc-fisico.nro-docto    = p-nro-docto
        AND   doc-fisico.serie-docto  = p-serie
        AND   doc-fisico.cod-emitente = p-emitente
        AND   doc-fisico.tipo-nota    = p-tipo-nota NO-ERROR.
    IF AVAIL DOc-fisico THEN DO:
        FOR EACH it-doc-fisico OF doc-fisico NO-LOCK 
            WHERE it-doc-fisico.baixa-ce = YES 
            AND   it-doc-fisico.nr-ord-produ = 0,
            EACH bfrat-lote NO-LOCK 
            WHERE bfrat-lote.nro-docto    = it-doc-fisico.nro-docto    
            AND   bfrat-lote.serie-docto  = it-doc-fisico.serie-docto  
            AND   bfrat-lote.cod-emitente = it-doc-fisico.cod-emitente 
            AND   bfrat-lote.nat-operacao = ""                        
            AND   bfrat-lote.sequencia    = it-doc-fisico.sequencia    
            AND   bfrat-lote.tipo-nota    = it-doc-fisico.tipo-nota,
            FIRST deposito NO-LOCK 
            WHERE deposito.cod-depos = bfrat-lote.cod-depos 
            AND &IF "{&mgscm_version}" >= "2.05" &THEN 
                    deposito.log-gera-wms = yes,
                &ELSE
                    deposito.log-2        = yes,
                &ENDIF
            FIRST item NO-LOCK
            WHERE item.it-codigo = it-doc-fisico.it-codigo
            BREAK BY bfrat-lote.cod-depos:

            IF ITEM.tipo-contr = 4 THEN
                NEXT.

            IF item.tipo-contr = 2 AND
                it-doc-fisico.conta-contabil <> "" THEN 
                NEXT.          

            CREATE tt-rat-lote.
            BUFFER-COPY bfrat-lote TO tt-rat-lote.
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice documento
  Parameters:  
               retorna valor do campo serie-docto
               retorna valor do campo nro-docto
               retorna valor do campo cod-emitente
               retorna valor do campo nat-operacao
               retorna valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pserie-docto LIKE rat-lote.serie-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pnro-docto LIKE rat-lote.nro-docto NO-UNDO.
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE rat-lote.cod-emitente NO-UNDO.
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE rat-lote.nat-operacao NO-UNDO.
    DEFINE OUTPUT PARAMETER psequencia LIKE rat-lote.sequencia NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pserie-docto = RowObject.serie-docto
           pnro-docto = RowObject.nro-docto
           pcod-emitente = RowObject.cod-emitente
           pnat-operacao = RowObject.nat-operacao
           psequencia = RowObject.sequencia.

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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
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
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRecFisico DBOProgram 
PROCEDURE getRecFisico :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param piRecFisico  as log  no-undo.
    
    assign piRecFisico =   avail docum-est
                       and docum-est.rec-fisico.

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice documento
  Parameters:  
               recebe valor do campo serie-docto
               recebe valor do campo nro-docto
               recebe valor do campo cod-emitente
               recebe valor do campo nat-operacao
               recebe valor do campo sequencia
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pserie-docto LIKE rat-lote.serie-docto NO-UNDO.
    DEFINE INPUT PARAMETER pnro-docto LIKE rat-lote.nro-docto NO-UNDO.
    DEFINE INPUT PARAMETER pcod-emitente LIKE rat-lote.cod-emitente NO-UNDO.
    DEFINE INPUT PARAMETER pnat-operacao LIKE rat-lote.nat-operacao NO-UNDO.
    DEFINE INPUT PARAMETER psequencia LIKE rat-lote.sequencia NO-UNDO.

    FIND FIRST bfrat-lote WHERE 
        bfrat-lote.serie-docto = pserie-docto AND 
        bfrat-lote.nro-docto = pnro-docto AND 
        bfrat-lote.cod-emitente = pcod-emitente AND 
        bfrat-lote.nat-operacao = pnat-operacao AND 
        bfrat-lote.sequencia = psequencia NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfrat-lote THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfrat-lote)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeFinds DBOProgram 
PROCEDURE initializeFinds :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


    run findItemDocumento ( i-cod-emitente,
                            c-serie-docto,
                            c-nro-docto,
                            c-nat-operacao,
                            i-sequencia ). 

    if  return-value <> "OK":U then
        return "NOK":U.
                  
    if avail item-doc-est then 
        
        run findDocumento ( item-doc-est.cod-emitente,
                            item-doc-est.serie-docto,
                            item-doc-est.nro-docto,
                            item-doc-est.nat-operacao ).

    if avail docum-est then do:
        run findNatureza ( docum-est.nat-operacao ).
      
        for first estabelec 
            fields ( cod-estabel deposito-cq )
            where estabelec.cod-estabel = docum-est.cod-estabel no-lock.
        end.    
    end.     

    if avail item-doc-est then
        run findItem ( item-doc-est.it-codigo ).
        
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToComponente DBOProgram 
PROCEDURE linkToComponente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pHandle AS HANDLE NO-UNDO.
    
    run getKey in pHandle (output c-serie-docto,
                           output c-nro-docto,
                           output i-cod-emitente,
                           output c-nat-operacao,
                           output c-it-codigo,
                           output c-cod-refer,
                           output i-sequencia).

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToItem-Doc-Est DBOProgram 
PROCEDURE linkToItem-Doc-Est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param pHandle as handle no-undo.

    run getKey in pHandle(output i-cod-emitente,
                          output c-serie-docto,
                          output c-nro-docto,
                          output c-nat-operacao,
                          output i-sequencia).
                          
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query qr{&tableName} for each {&tableName}
       no-lock
       indexed-reposition.


  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstMain DBOProgram 
PROCEDURE findFirstMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastMain DBOProgram 
PROCEDURE findLastMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextMain DBOProgram 
PROCEDURE findNextMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevMain DBOProgram 
PROCEDURE findPrevMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfDocumEst DBOProgram 
PROCEDURE openQueryOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         no-lock 
         indexed-reposition.
         
         
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstOfDocumEst DBOProgram 
PROCEDURE findFirstOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK WHERE
               {&tableName}.cod-emitente = i-cod-emitente AND
               {&tableName}.serie-docto  = c-serie-docto  AND
               {&tableName}.nro-docto    = c-nro-docto    AND
               {&tableName}.nat-operacao = c-nat-operacao NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastOfDocumEst DBOProgram 
PROCEDURE findLastOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK WHERE
              {&tableName}.cod-emitente = i-cod-emitente AND
              {&tableName}.serie-docto  = c-serie-docto  AND
              {&tableName}.nro-docto    = c-nro-docto    AND
              {&tableName}.nat-operacao = c-nat-operacao NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextOfDocumEst DBOProgram 
PROCEDURE findNextOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK WHERE
              {&tableName}.cod-emitente = i-cod-emitente AND
              {&tableName}.serie-docto  = c-serie-docto  AND
              {&tableName}.nro-docto    = c-nro-docto    AND
              {&tableName}.nat-operacao = c-nat-operacao NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevOfDocumEst DBOProgram 
PROCEDURE findPrevOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK WHERE
              {&tableName}.cod-emitente = i-cod-emitente AND
              {&tableName}.serie-docto  = c-serie-docto  AND
              {&tableName}.nro-docto    = c-nro-docto    AND
              {&tableName}.nat-operacao = c-nat-operacao NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfItemDocEst DBOProgram 
PROCEDURE openQueryOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName}
       where {&tableName}.cod-emitente = i-cod-emitente
         and {&tableName}.serie-docto  = c-serie-docto
         and {&tableName}.nro-docto    = c-nro-docto
         and {&tableName}.nat-operacao = c-nat-operacao
         and {&tableName}.sequencia    = i-sequencia
         no-lock 
         indexed-reposition.
         
         
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findFirstOfItemDocEst DBOProgram 
PROCEDURE findFirstOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST {&TableName} NO-LOCK WHERE
               {&tableName}.cod-emitente = i-cod-emitente AND
               {&tableName}.serie-docto  = c-serie-docto  AND
               {&tableName}.nro-docto    = c-nro-docto    AND
               {&tableName}.nat-operacao = c-nat-operacao AND
               {&tableName}.sequencia    = i-sequencia    NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findLastOfItemDocEst DBOProgram 
PROCEDURE findLastOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND LAST {&TableName} NO-LOCK WHERE
              {&tableName}.cod-emitente = i-cod-emitente AND
              {&tableName}.serie-docto  = c-serie-docto  AND
              {&tableName}.nro-docto    = c-nro-docto    AND
              {&tableName}.nat-operacao = c-nat-operacao AND
              {&tableName}.sequencia    = i-sequencia    NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNextOfItemDocEst DBOProgram 
PROCEDURE findNextOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND NEXT {&TableName} NO-LOCK WHERE
              {&tableName}.cod-emitente = i-cod-emitente AND
              {&tableName}.serie-docto  = c-serie-docto  AND
              {&tableName}.nro-docto    = c-nro-docto    AND
              {&tableName}.nat-operacao = c-nat-operacao AND
              {&tableName}.sequencia    = i-sequencia    NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findPrevOfItemDocEst DBOProgram 
PROCEDURE findPrevOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FIND PREV {&TableName} NO-LOCK WHERE
              {&tableName}.cod-emitente = i-cod-emitente AND
              {&tableName}.serie-docto  = c-serie-docto  AND
              {&tableName}.nro-docto    = c-nro-docto    AND
              {&tableName}.nat-operacao = c-nat-operacao AND
              {&tableName}.sequencia    = i-sequencia    NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintMain DBOProgram 
PROCEDURE setConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.

END PROCEDURE.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfComponente DBOProgram 
PROCEDURE setConstraintOfComponente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER p-c-it-codigo    LIKE {&TableName}.it-codigo    NO-UNDO.
   DEFINE INPUT PARAMETER p-i-cod-emitente LIKE {&TableName}.cod-emitente NO-UNDO.
   DEFINE INPUT PARAMETER p-c-serie-docto  LIKE {&TableName}.serie-docto  NO-UNDO.
   DEFINE INPUT PARAMETER p-c-nro-docto    LIKE {&TableName}.nro-docto    NO-UNDO.
   DEFINE INPUT PARAMETER p-c-nat-operacao LIKE {&TableName}.nat-operacao NO-UNDO.
   DEFINE INPUT PARAMETER p-c-cod-refer    LIKE {&TableName}.cod-refer    NO-UNDO.
   DEFINE INPUT PARAMETER p-i-sequencia    LIKE {&TableName}.sequencia    NO-UNDO.

   ASSIGN c-it-codigo    = p-c-it-codigo
          i-cod-emitente = p-i-cod-emitente
          c-serie-docto  = p-c-serie-docto
          c-nro-docto    = p-c-nro-docto
          c-nat-operacao = p-c-nat-operacao
          c-cod-refer    = p-c-cod-refer
          i-sequencia    = p-i-sequencia.
          
   RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfDocumEst DBOProgram 
PROCEDURE setConstraintOfDocumEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.

    assign i-cod-emitente = i-cod-emit
           c-serie-docto  = c-ser-docto
           c-nro-docto    = c-nr-docto
           c-nat-operacao = c-nat-oper.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintOfItemDocEst DBOProgram 
PROCEDURE setConstraintOfItemDocEst :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-cod-emit  as int  no-undo.
    def input param c-ser-docto as char no-undo.
    def input param c-nr-docto  as char no-undo.
    def input param c-nat-oper  as char no-undo.
    def input param i-seq       as int  no-undo.

    assign i-cod-emitente = i-cod-emit
           c-serie-docto  = c-ser-docto
           c-nro-docto    = c-nr-docto
           c-nat-operacao = c-nat-oper
           i-sequencia    = i-seq.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateItem DBOProgram 
PROCEDURE validateItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param piItem        like item-doc-est.it-codigo  no-undo.
    def input param piCodRefer    like item-doc-est.cod-refer  no-undo.
    def input param piBaixaEstoq  like item-doc-est.baixa-ce   no-undo.

    def var l-configurado         as log                       no-undo.
    def var h-ceapi030            as handle                    no-undo.
    DEF VAR l-lote-vencido        AS LOG                       NO-UNDO.
    DEF VAR c-lista               AS CHAR                      NO-UNDO.
    DEF VAR i-espec               AS INT FORMAT 99             NO-UNDO.
    DEF VAR l-valida-qtde         AS LOGICAL                   NO-UNDO.
    DEF BUFFER b-rat-lote FOR rat-lote.

    run getConfigurado ( piItem,
                         piBaixaEstoq,
                         output l-configurado ).
                         
    if  l-configurado
    and piBaixaEstoq then
        run findItem ( piItem ).
    
    if  return-value = "NOK":U then
        return "NOK":U.


    if  item.tipo-con-est <> 1 AND /* Contr. Nr Serie, Lote ou Referencia */
        RowObject.lote = " "  THEN DO:
            {method/svc/errors/inserr.i
                                &ErrorNumber="1818"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=" "}
    END.
    

    /* Controle por Lote ou Referencia */
    if  (item.tipo-con-est = 3 or item.tipo-con-est = 4) THEN DO:

        IF RowObject.dt-vali-lote = ? THEN DO:
            {utp/ut-liter.i Validade_do_lote *}
            {method/svc/errors/inserr.i &ErrorNumber="688"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters="RETURN-VALUE"}
        END.

        IF RowObject.dat-fabricc-lote > TODAY THEN DO:
            {utp/ut-liter.i de_Fabricaá∆o *}
            {method/svc/errors/inserr.i
                                &ErrorNumber="15332"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters="RETURN-VALUE"}
        END.
    END.

    IF  i-pais-impto-usuario = 1 AND
        CAN-FIND( FIRST funcao
                  WHERE funcao.cd-funcao = "WMS-SAAS"
                    AND funcao.ativo     = YES) AND
        CAN-FIND(FIRST deposito NO-LOCK
                 WHERE deposito.cod-depos = RowObject.cod-depos
                   AND deposito.log-wms-externo) AND
        RowObject.cod-localiz <> "" THEN DO:
        {method/svc/errors/inserr.i
                            &ErrorNumber="57560"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR"}
    END.

    if  not item.loc-unica then
        run findLocalizacao ( docum-est.cod-estabel,
                              RowObject.cod-localiz,
                              RowObject.cod-depos ).

    /* Verifica saldo em estoque para item controlado por numero de serie */ 
    if  item.tipo-con-est = 2 
    and avail natur-oper
    and natur-oper.tipo = 1 
    /*and natur-oper.tp-oper-terc <> 2*/
    and not docum-est.rec-fisico then do:

        assign l-valida-qtde = yes.

        /* rat-lote ser· criada na bocx220a.i1 com as informaÁıes da tela im0100a */
        if docum-est.declaracao-import <> "" and item.tipo-con-est = 2 and docum-est.origem = "i" then
            assign l-valida-qtde = no.

        if  rowobject.quantidade > 1 and l-valida-qtde then do:
            /*Item controlado por n£mero de sÇrie requer quantidade 0 ou 1 */
            {method/svc/errors/inserr.i
                                &ErrorNumber="1836"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=" "}
        end.          
        
        if  c-tipo = "Create":U then do:
            find first b-rat-lote {cdp/cd8900.i b-rat-lote docum-est}    
                 and b-rat-lote.it-codigo  = RowObject.it-codigo 
                 and b-rat-lote.lote       = RowObject.lote no-lock no-error.
        
            if  avail b-rat-lote then do:
                /* Item Controlado por Nr. Serie ja Existe em Outra Sequencia */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="6388"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}
            end.          
        end.
        ELSE DO:
            IF c-tipo = "UPDATE" THEN DO:
                find first b-rat-lote {cdp/cd8900.i b-rat-lote docum-est}    
                     and   b-rat-lote.it-codigo  = RowObject.it-codigo 
                     and   b-rat-lote.lote       = RowObject.lote no-lock no-error.

                if  avail b-rat-lote AND
                    b-rat-lote.sequencia <> RowObject.sequencia then do:
                    /* Item Controlado por Nr. Serie ja Existe em Outra Sequencia */
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="6388"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=" "}
                end.          
            END.
        END.

        IF item-doc-est.ct-codigo = "" THEN
            FOR FIRST saldo-estoq FIELDS(it-codigo lote qtidade-atu)
                WHERE saldo-estoq.it-codigo    = RowObject.it-codigo
                  AND saldo-estoq.cod-estabel  = docum-est.cod-estabel
                  AND saldo-estoq.cod-depos    = RowObject.cod-depos
                  AND saldo-estoq.cod-localiz  = RowObject.cod-localiz
                  AND saldo-estoq.lote         = RowObject.lote
                  AND saldo-estoq.qtidade-atu  > 0 NO-LOCK: 

                /* Item Controlado por Nr. Serie ja Existe em Saldo Estoque */
            {method/svc/errors/inserr.i
                                &ErrorNumber="1252"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR" 
                                &ErrorParameters=" "}
            END. 
    end.
    
    if  avail param-estoq 
    and item.tipo-con-est = 4 then /* Controlado por Referencia */
        
        if  substr(param-estoq.char-2,1,1) <> "#" then do:
            
            for first saldo-estoq 
                fields ( it-codigo lote cod-refer ) use-index lote
                where saldo-estoq.it-codigo = RowObject.it-codigo
                and   saldo-estoq.lote      = RowObject.lote no-lock.
            end.

            if  avail saldo-estoq
            and saldo-estoq.cod-refer <> piCodRefer then do:
                /* Referencia informada nao confere com a referendia do lote. */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="1785"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}
            end.
        end.

        /****  A validaá∆o abaixo passou a ser executada no VALIDATERECORD  *****/

        /*     if (item.tipo-con-est = 3 or item.tipo-con-est = 4 ) then do:                 */
        /*         find first b-rat-lote {cdp/cd8900.i b-rat-lote docum-est }                */
        /*                and b-rat-lote.it-codigo     = RowObject.it-codigo                  */
        /*                and b-rat-lote.lote          = RowObject.lote                       */
        /*                and b-rat-lote.dt-vali-lote <> RowObject.dt-vali-lote               */
        /*                and rowid(b-rat-lote)       <> RowObject.r-rowid no-lock no-error.  */
        /*         if  avail b-rat-lote then do:                                             */
        /*                                                                                   */
        /*             /* Lote j† Informado com outra Data de Validade. */                   */
        /*             {method/svc/errors/inserr.i                                           */
        /*                                 &ErrorNumber="26642"                              */
        /*                                 &ErrorType="EMS"                                  */
        /*                                 &ErrorSubType="ERROR"                             */
        /*                                 &ErrorParameters=" "}                             */
        /*         end.                                                                      */
        /*     end.                                                                          */


   /* valida fator de concentracao / ppm */
   &if defined (bf_man_per_ppm) &then 
      if item.tipo-con-est = 3 THEN DO:
         IF ITEM.tipo-formula = 2 OR ITEM.tipo-formula = 3 then do: /* concentracao ou ppm */

            if rowobject.per-ppm = 0 then do:
               find first saldo-estoq
                    where saldo-estoq.it-codigo  = rowobject.it-codigo
                      and saldo-estoq.LOTE       = rowobject.LOTE NO-LOCK NO-ERROR.
               IF AVAIL SALDO-ESTOQ THEN ASSIGN rowobject.per-ppm = saldo-estoq.per-ppm.  
               ELSE ASSIGN rowobject.PER-PPM = ITEM.PER-PPM.         
            end.
            else do:
               find FIRST  b-rat-lote {cdp/cd8900.i b-rat-lote docum-est }
                       and b-rat-lote.it-codigo = RowObject.it-codigo 
                       and b-rat-lote.lote      = RowObject.lote 
                       and b-rat-lote.per-ppm  <> RowObject.per-ppm
                       and rowid(b-rat-lote)   <> RowObject.r-rowid no-lock no-error.
               if  avail b-rat-lote 
                    AND c-tipo = "Create":U then do:
                    {utp/ut-liter.i "Lote_j†_informado_com_outro_fator_de_Concentraá∆o/Ppm." *}
                    ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
                    {method/svc/errors/inserr.i
                        &ErrorNumber="17006"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR" 
                        &ErrorParameters="c-lb-msg"}
               end.               
               ELSE DO:
                   FIND FIRST saldo-estoq 
                       WHERE  saldo-estoq.it-codigo   = RowObject.it-codigo 
                       AND    saldo-estoq.lote        = rowobject.lote
                       AND    saldo-estoq.per-ppm    <> RowObject.per-ppm
                       NO-LOCK NO-ERROR.
                   IF  AVAIL saldo-estoq THEN DO:
                   
                       IF NOT CAN-FIND (FIRST ficha-cq
                            WHERE ficha-cq.nr-ficha     = RowObject.nr-ficha
                            AND   ficha-cq.serie-docto  = RowObject.serie-docto
                            AND   ficha-cq.nro-docto    = RowObject.nro-docto
                            AND   ficha-cq.nat-operacao = RowObject.nat-operacao
                            AND   ficha-cq.cod-emitente = RowObject.cod-emitente
                            AND   ficha-cq.it-codigo    = RowObject.it-codigo 
                            AND   ficha-cq.lote         = RowObject.lote 
                            AND   ficha-cq.situacao     = 4 /*Terminado*/ ) THEN DO:   
                       
                           {utp/ut-liter.i "Existe_saldo_em_estoque_com_fator_concentraá∆o/ppm_diferente_para_este_lote." *}
                           ASSIGN c-lb-msg = TRIM(RETURN-VALUE).
                           {method/svc/errors/inserr.i
                               &ErrorNumber="17006"
                               &ErrorType="EMS"
                               &ErrorSubType="ERROR" 
                               &ErrorParameters="c-lb-msg"}
                       END. /*can-find*/
                   END. /*if avail saldo-estoq*/ 
               END. /*else do*/
            END.
         END.
         else assign rowobject.per-ppm = 0.   /* nao utiliza ou veiculo */
         /* termino validacao fator de concentracao / ppm */
      end.         
      ELSE DO:  /* nao utiliza ou veiculo */
         ASSIGN ROWOBJECT.PER-PPM = 0.
      END.
   &endif
    if  item.tipo-con-est > 2  /* Controlado por Lote ou Referencia */
    and (   RowObject.dt-vali-lote = ? 
         or RowObject.dt-vali-lote < today ) then do:
    
        if  avail docum-est
        and docum-est.cod-observa = 3 /* Devoluá∆o cliente */
        or  (    avail natur-oper
             and natur-oper.terceiros
             and (   natur-oper.tp-oper-terc = 2              /* Retorno Beneficiamento */
                  or natur-oper.tp-oper-terc = 5 )) then do:  /* Devoluá∆o Consignaá∆o */
        
            IF NOT VALID-HANDLE(h-boin060) THEN
            run inbo/boin060.p persistent set h-boin060.
        
            run updateConsistNota in h-boin060 ( RowObject.cod-emitente,
                                                 RowObject.serie-docto,
                                                 RowObject.nro-docto,
                                                 RowObject.nat-operacao,
                                                 RowObject.sequencia,
                                                 no,
                                                 0,
                                                 0,
                                                 1247,
                                                 2).
            IF VALID-HANDLE(h-boin060) THEN DO:
                DELETE PROCEDURE h-boin060.
                ASSIGN h-boin060 = ?.
            END.
        end.
        else do:    
            &if '{&bf_lote_avancado_liberado}' = 'yes' &then
                if l-lote-avancado then do:
                    if not valid-handle(h-ceapi030) then
                        run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                                      output table tt-valores,
                                                                      output table tt-erro).
                    ASSIGN c-lista = {ininc/i03in218.i 03}
                           i-espec = LOOKUP(natur-oper.especie-doc, c-lista).
                    
                    IF VALID-HANDLE(h-ceapi030) THEN DO:
                        run pi-verifica-lote-vencido in h-ceapi030 (input RowObject.it-codigo,
                                                                    input docum-est.cod-estabel,
                                                                    input i-espec,
                                                                    output l-lote-vencido).
                        DELETE PROCEDURE h-ceapi030.
                        ASSIGN h-ceapi030 = ?.
                    END.
                end.
            &endif
            
            IF NOT l-lote-vencido THEN DO:
        
                /****** PONTO UPC - Chamado TPNNFC *******/
                IF c-nom-prog-dpc-mg97  <> ""
                OR c-nom-prog-upc-mg97  <> ""
                OR c-nom-prog-appc-mg97 <> "" THEN DO:
                
                    EMPTY TEMP-TABLE tt-epc.
        
                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "VerificaTipoOper"
                           tt-epc.cod-parameter = "Nat-operacao"
                           tt-epc.val-parameter = STRING(natur-oper.nat-operacao).
                
                    /*** Chamada do programa EPC ***/
                    {include/i-epc201.i  "VerificaTipoOper" }
       
                    IF NOT CAN-FIND(FIRST tt-epc
                                    WHERE tt-epc.cod-event     = "VerificaTipoOper"  
                                      AND tt-epc.cod-parameter = "Transf":U ) THEN DO:
                        {method/svc/errors/inserr.i
                                    &ErrorNumber="1247"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}
                    END.
                END.
                /*************Fim***************/   
            END.
        end.
    end.
    else do:

        if  avail docum-est
        and docum-est.cod-observa = 3 /* Devoluá∆o cliente */
        or  (    avail natur-oper
             and natur-oper.terceiros
             and (   natur-oper.tp-oper-terc = 2              /* Retorno Beneficiamento */
                  or natur-oper.tp-oper-terc = 5 )) then do:  /* Devoluá∆o Consignaá∆o */
                    
            IF NOT VALID-HANDLE(h-boin060) THEN
               run inbo/boin060.p persistent set h-boin060.

           
            run updateConsistNota in h-boin060 ( RowObject.cod-emitente,
                                                 RowObject.serie-docto,
                                                 RowObject.nro-docto,
                                                 RowObject.nat-operacao,
                                                 RowObject.sequencia,
                                                 yes,
                                                 0,
                                                 0,
                                                 1247,
                                                 2).

            IF VALID-HANDLE(h-boin060) THEN DO:
                DELETE PROCEDURE h-boin060.
                ASSIGN h-boin060 = ?.
            END.

        end.
    end.
    
    /********* CHAMADA EPC PARA VALIDACOES ESPECIFICAS **********/
    for each tt-epc where
             tt-epc.cod-event = "afterValidateItem":U.
         delete tt-epc.
    end.
    
    {include/i-epc200.i2 &CodEvent       = "'afterValidateItem'"
                         &CodParameter   = "'OBJECT-HANDLE'"
                         &ValueParameter = STRING(THIS-PROCEDURE)}
    
    {include/i-epc201.i "afterValidateItem"}
    /***********************************************************/

    /*--- Verifica ocorr^ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateQtde DBOProgram 
PROCEDURE validateQtde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piPtype       as char                       no-undo.
    def input param piBaixaEstoq  like item-doc-est.baixa-ce    no-undo.
    def input param piQtdeItem    like item-doc-est.quantidade  no-undo.
    
/*******
    def var de-qt-acumulada       as dec                        no-undo.
    def var l-configurado         as log                        no-undo.
     
    run getConfigurado ( RowObject.it-codigo,
                         piBaixaEstoq,
                         output l-configurado ).
*******/                         
            
    IF  RowObject.quantidade = 0 AND
        NOT docum-est.rec-fisico THEN DO:
        {method/svc/errors/inserr.i
                            &ErrorNumber="1570"
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" 
                            &ErrorParameters=" "}
    END.

    /*--- Verifica ocorr^ncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    def var l-configurado         as log                    no-undo.
    
    /*--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as validaá‰es ---*/

    assign c-tipo = pType.

    IF pType = "Create" THEN DO:
        IF  l-executa-engine THEN DO:
            RUN pi-engine-deposito (INPUT-OUTPUT RowObject.cod-depos,
                                    INPUT-OUTPUT RowObject.cod-localiz).
        END.
    END.

    run findDocumento ( RowObject.cod-emitente,
                        RowObject.serie-docto,
                        RowObject.nro-docto,
                        RowObject.nat-operacao ).
    
    if  return-value <> "OK":U then
        return "NOK":U.                         

    IF pType = "Update"
    OR pType = "delete" THEN DO:
        IF NOT docum-est.rec-fisico AND
           (docum-est.ind-sit-wms-ext  <> 0  and /*Digitada*/
            docum-est.ind-sit-wms-ext  <> 1  and /*N∆o Integra*/
            docum-est.ind-sit-wms-ext  <> 5  and /*Conferencia NOK*/
            docum-est.ind-sit-wms-ext  <> 6) then do: /*Inativo*/
            {method/svc/errors/inserr.i &ErrorNumber="57473"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" }
        END.
    END.

    if  docum-est.ce-atual then do:
        {method/svc/errors/inserr.i
                            &ErrorNumber="19515" /*Nota fiscal j† atualizada*/
                            &ErrorType="EMS"
                            &ErrorSubType="ERROR" }
    end.        
    
    if  pType <> "Delete":U then do:
        
        run findItemDocumento ( RowObject.cod-emitente,
                                RowObject.serie-docto,
                                RowObject.nro-docto,
                                RowObject.nat-operacao,
                                RowObject.sequencia ). 
        
        if  return-value <> "OK":U then
            return "NOK":U.                            
    
        run findNatureza ( RowObject.nat-operacao ).
        
        if  return-value <> "OK":U then
            return "NOK":U.             
                
        run getConfigurado ( item-doc-est.it-codigo, 
                             item-doc-est.baixa-ce,  
                             output l-configurado ). 

        run validateItem ( RowObject.it-codigo,
                           IF l-configurado THEN
                              RowObject.cod-refer
                           ELSE item-doc-est.cod-refer,
                           l-baixa-estoq ).
    

        run findDeposito ( RowObject.cod-depos ).
        
        /* Valida se o dep¢sito for CQ e o item n∆o CQ, n∆o deixa prosseguir  */
        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.cod-emitente   = RowObject.cod-emitente AND
                  docum-est.serie-docto    = RowObject.serie-docto  AND
                  docum-est.nro-docto      = RowObject.nro-docto    AND
                  docum-est.nat-operacao   = RowObject.nat-operacao: 
            IF  CAN-FIND(FIRST item-uni-estab NO-LOCK
                         WHERE item-uni-estab.it-codigo      = RowObject.it-codigo   AND
                               item-uni-estab.cod-estabel    = docum-est.cod-estabel AND
                               item-uni-estab.contr-qualid   = NO) AND
                CAN-FIND(FIRST deposito NO-LOCK
                         WHERE deposito.cod-depos = RowObject.cod-depos AND
                               deposito.ind-dep-cq) THEN DO:
                        {method/svc/errors/inserr.i
                                            &ErrorNumber="57097"
                                            &ErrorType="EMS"
                                            &ErrorSubType="ERROR"}
            END.
        END.
         
        run validateSaldo ( IF l-configurado THEN
                               RowObject.cod-refer
                            ELSE item-doc-est.cod-refer,
                            l-baixa-estoq ).
        
        run validateQtde ( pType,
                           l-baixa-estoq,
                           de-qtde-item ).

        if (item.tipo-con-est = 3 or item.tipo-con-est = 4 ) then do:
            find first b-rat-lote {cdp/cd8900.i b-rat-lote docum-est }
                   and b-rat-lote.it-codigo     = RowObject.it-codigo 
                   and b-rat-lote.lote          = RowObject.lote 
                   and b-rat-lote.dt-vali-lote <> RowObject.dt-vali-lote
                   and rowid(b-rat-lote)       <> RowObject.r-rowid no-lock no-error.
            if  avail b-rat-lote then do:
        
                /* Lote j† Informado com outra Data de Validade. */
                {method/svc/errors/inserr.i
                                    &ErrorNumber="26642"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" 
                                    &ErrorParameters=" "}
            end.
        end.
    end.                           

    IF pType = "UPDATE"
    OR pType = "DELETE" THEN DO:
        FIND FIRST doc-fisico NO-LOCK
             WHERE doc-fisico.nro-docto    = RowObject.nro-docto
               AND doc-fisico.serie-docto  = RowObject.serie-docto
               AND doc-fisico.cod-emitente = RowObject.cod-emitente
               AND doc-fisico.tipo-nota    = RowObject.tipo-nota NO-ERROR.
        IF AVAIL doc-fisico THEN DO:
            IF  doc-fisico.ind-sit-wms-ext = 2 THEN DO: //Aguardando
                {method/svc/errors/inserr.i
                                    &ErrorNumber="57470"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            END.
            IF  doc-fisico.ind-sit-wms-ext = 3 THEN DO: //Em processo
                {method/svc/errors/inserr.i
                                    &ErrorNumber="57471"
                                    &ErrorType="EMS"
                                    &ErrorSubType="ERROR" }
            END.
        END.
    END.

    /********* CHAMADA EPC PARA VALIDACOES ESPECIFICAS **********/
    for each tt-epc where
             tt-epc.cod-event = "fim-validacoes":U.
         delete tt-epc.
    end.
    
    {include/i-epc200.i2 &CodEvent       = "'fim-validacoes'"
                         &CodParameter   = "'OBJECT-HANDLE'"
                         &ValueParameter = STRING(THIS-PROCEDURE)}
                         
    {include/i-epc201.i "fim-validacoes"}                     
    /***********************************************************/
    
    /*--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateSaldo DBOProgram 
PROCEDURE validateSaldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    def input param piCodRefer    like item-doc-est.cod-refer no-undo.
    def input param piBaixaEstoq  as log                      no-undo.
    
    def var de-saldo-disp         as dec                      no-undo.

  &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    def var h-ceapi030      as handle no-undo.
    def var l-retorno       as log    no-undo.

    if l-lote-avancado then do:
        if not valid-handle(h-ceapi030) then
            run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                          output table tt-valores,
                                                          output table tt-erro).
    end.
  &endif
    
    if  avail natur-oper
    and natur-oper.tipo = 2 then do: /* Saida pelo Re4001 - Internacional */ 
    
        for first saldo-estoq 
            fields ( cod-estabel cod-depos   cod-localiz 
                     lote        it-codigo   cod-refer
                     qt-alocada  qt-aloc-ped qt-aloc-prod )
            where saldo-estoq.cod-estabel = docum-est.cod-estabel
              and saldo-estoq.cod-depos   = RowObject.cod-depos
              and saldo-estoq.cod-localiz = RowObject.cod-localiz
              and saldo-estoq.lote        = RowObject.lote
              and saldo-estoq.it-codigo   = RowObject.it-codigo
              and saldo-estoq.cod-refer   = piCodRefer  no-lock.
        end.

      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
        assign l-retorno = yes.

        find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
        if l-lote-avancado and
           avail saldo-estoq and
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
            if return-value = "nok":u then do:
                for each tt-erro:
                    {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                &ErrorType="EMS"
                                                &ErrorSubType="ERROR" 
                                                &ErrorParameters=tt-erro.mensagem}
                end.
            end.

        end.
        IF VALID-HANDLE(h-ceapi030) THEN DO:
            DELETE PROCEDURE h-ceapi030.
            ASSIGN h-ceapi030 = ?.
        END.
        if not l-retorno then
            {method/svc/errors/inserr.i &ErrorNumber="36669"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=saldo-estoq.lote}
        else do:
      &endif
           
        assign de-saldo-disp = if  not avail saldo-estoq 
                               or  saldo-estoq.qt-alocada < 0 
                               then 0
                               else 
                                   if  avail saldo-estoq
                                   then (  saldo-estoq.qtidade-atu 
                                         - saldo-estoq.qt-alocada  
                                         - saldo-estoq.qt-aloc-ped 
                                         - saldo-estoq.qt-aloc-prod)
                                   else 0.
                                      
        if  de-saldo-disp < RowObject.quantidade then

            if  piBaixaEstoq
            and item.tipo-contr <> 4  /* Diferente de Debito Direto */
            and can-do("1,2",string(item.perm-saldo-neg)) then do:

                if  item.perm-saldo-neg = 1 then do:
                    {method/svc/errors/inserr.i
                                        &ErrorNumber="7165"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters=" "}
                end.   
                else do:


                DEFINE VARIABLE c-msg-aux AS CHARACTER NO-UNDO.

                ASSIGN c-msg-aux = RowObject.it-codigo          + '~~' +
                                   piCodRefer                   + '~~' +
                                   STRING(i-sequencia)          + '~~' +
                                   string(de-saldo-disp)        + '~~' +
                                   string(RowObject.quantidade) + '~~' +
                                   docum-est.cod-estabel        + '~~' +
                                   RowObject.cod-depos          + '~~' +
                                   RowObject.cod-localiz        + '~~' +
                                   RowObject.lote.


                    {method/svc/errors/inserr.i
                                        &ErrorNumber="15450"
                                        &ErrorType="EMS"
                                        &ErrorSubType="ERROR" 
                                        &ErrorParameters= c-msg-aux } 
                end.   
            end.
      &if '{&bf_lote_avancado_liberado}' = 'yes' &then
         end.
      &endif
    end.
    
    IF  AVAIL natur-oper
    AND NOT docum-est.origem = "i":U
    AND NOT docum-est.origem = "XML":U THEN DO:
    
        IF  ITEM.tipo-con-est <> 1 
        AND not natur-oper.transf
        and ((natur-oper.terceiros 
              and ( natur-oper.tp-oper-terc = 2      /* Retorno Beneficiamento */ 
                    or natur-oper.tp-oper-terc = 5   /* Devol. Consignacao */    
                    or natur-oper.tp-oper-terc = 9   /*Retorno Dep Fechado*/
                    or natur-oper.tp-oper-terc = 11)) /*Retorno Armaz Geral*/
             or natur-oper.tipo-compra = 3) /* Devoluá∆o Cliente */ then 
           run validaSaldoByLote.
    END.


    /********* CHAMADA EPC PARA VALIDACOES ESPECIFICAS **********/
    for each tt-epc where
             tt-epc.cod-event = "fim-valida-saldo":U.
         delete tt-epc.
    end.

    {include/i-epc200.i2 &CodEvent       = "'fim-valida-saldo'"
                         &CodParameter   = "'OBJECT-HANDLE'"
                         &ValueParameter = STRING(THIS-PROCEDURE)}
                         
    {include/i-epc201.i "fim-valida-saldo"}                     
    /***********************************************************/

    return "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaSaldoByLote DBOProgram 
PROCEDURE validaSaldoByLote :
    DEF BUFFER bf-item-doc-est FOR item-doc-est.
    DEF BUFFER bf-fat-ser-lote FOR fat-ser-lote.
    DEF BUFFER bf2-rat-lote    FOR rat-lote.

    DEF VAR c-cod-estabel LIKE estabelec.cod-estabel NO-UNDO.

    empty temp-table tt-saldo-lote.

    assign c-cod-estabel = if  natur-oper.transf 
                           then docum-est.estab-de-or
                           else docum-est.cod-estabel.

    IF AVAIL natur-oper 
       and ( natur-oper.tp-oper-terc = 2  /* Retorno Beneficiamento - para notas de terceiro sempre ser† um erro, pois n∆o baixa saldo-terc corretamente */ 
          or natur-oper.tp-oper-terc = 5  /* Devol. Consignacao */ 
          or natur-oper.tp-oper-terc = 9  /* Retorno Dep Fechado */   
          or natur-oper.tp-oper-terc = 11 ) then do: /*Retorno Armaz Geral*/

          IF CAN-FIND (FIRST rat-saldo-terc 
                       WHERE rat-saldo-terc.cod-emitente = item-doc-est.cod-emitente      
                       AND   rat-saldo-terc.serie-docto  = item-doc-est.serie-comp
                       AND   rat-saldo-terc.nro-docto    = item-doc-est.nro-comp  
                       AND   rat-saldo-terc.sequencia    = item-doc-est.seq-comp  
                       AND   rat-saldo-terc.it-codigo    = RowObject.it-codigo) THEN DO:

              IF NOT CAN-FIND (FIRST rat-saldo-terc 
                               WHERE rat-saldo-terc.cod-emitente = item-doc-est.cod-emitente      
                               AND   rat-saldo-terc.serie-docto  = item-doc-est.serie-comp
                               AND   rat-saldo-terc.nro-docto    = item-doc-est.nro-comp  
                               AND   rat-saldo-terc.sequencia    = item-doc-est.seq-comp  
                               AND   rat-saldo-terc.lote         = rowObject.lote         
                               AND   rat-saldo-terc.it-codigo    = RowObject.it-codigo) THEN DO:
    
                                run utp/ut-msgs.p (input "msg":U, input 52369, input "":u).
                
                                create RowErrors.
                                assign RowErrors.ErrorNumber      = 52369
                                       RowErrors.ErrorDescription = return-value
                                       RowErrors.ErrorSubtype     = "ERROR":U.
              END.
          END.

    END.
    ELSE DO:
    
        FIND FIRST fat-ser-lote
             where fat-ser-lote.cod-estabel = c-cod-estabel
               and fat-ser-lote.serie       = item-doc-est.serie-comp
               and fat-ser-lote.nr-nota-fis = item-doc-est.nro-comp         
               and fat-ser-lote.nr-seq-fat  = item-doc-est.seq-comp
               AND fat-ser-lote.nr-serlote  = rowObject.lote
               AND fat-ser-lote.cod-localiz = rowObject.cod-localiz
               AND fat-ser-lote.cod-depos   = rowObject.cod-depos
               AND fat-ser-lote.it-codigo   = RowObject.it-codigo NO-LOCK NO-ERROR.

        IF AVAIL fat-ser-lote THEN DO:
    
            create tt-saldo-lote.
            assign tt-saldo-lote.it-codigo    = item-doc-est.it-codigo
                   tt-saldo-lote.lote         = rowObject.lote
                   tt-saldo-lote.cod-localiz  = RowObject.cod-localiz
                   tt-saldo-lote.cod-depos    = RowObject.cod-depos.
    
            FOR EACH bf-fat-ser-lote NO-LOCK
               where bf-fat-ser-lote.cod-estabel = c-cod-estabel
                 and bf-fat-ser-lote.serie       = item-doc-est.serie-comp
                 and bf-fat-ser-lote.nr-nota-fis = item-doc-est.nro-comp         
                 and bf-fat-ser-lote.nr-seq-fat  = item-doc-est.seq-comp
                 AND bf-fat-ser-lote.nr-serlote  = rowObject.lote
                 AND bf-fat-ser-lote.it-codigo   = RowObject.it-codigo:
    
                ASSIGN tt-saldo-lote.quantidade  = tt-saldo-lote.quantidade + bf-fat-ser-lote.qt-baixada[1].
            END.
    
            FOR EACH bf-item-doc-est 
               where bf-item-doc-est.cod-emitente   = item-doc-est.cod-emitente
                 and bf-item-doc-est.serie-comp     = item-doc-est.serie-comp
                 and bf-item-doc-est.nro-comp       = item-doc-est.nro-comp 
                 and bf-item-doc-est.nat-comp       = item-doc-est.nat-comp                    
                 and bf-item-doc-est.seq-comp       = item-doc-est.seq-comp 
                 and bf-item-doc-est.it-codigo      = item-doc-est.it-codigo no-lock:
    
                if rowid(bf-item-doc-est) = rowid(item-doc-est) then next.
    	    
                 for each bf2-rat-lote 
                    where bf2-rat-lote.cod-emitente = bf-item-doc-est.cod-emitente
                      and bf2-rat-lote.serie-docto  = bf-item-doc-est.serie-docto 
                      and bf2-rat-lote.nat-operacao = bf-item-doc-est.nat-operacao
                      and bf2-rat-lote.nro-docto    = bf-item-doc-est.nro-docto   
                      and bf2-rat-lote.sequencia    = bf-item-doc-est.sequencia
                      and bf2-rat-lote.lote         = fat-ser-lote.nr-serlote
                      AND bf2-rat-lote.cod-localiz  = fat-ser-lote.cod-localiz
                      AND bf2-rat-lote.cod-depos    = fat-ser-lote.cod-depos
                      AND bf2-rat-lote.it-codigo    = fat-ser-lote.it-codigo no-lock:
    
                     ASSIGN tt-saldo-lote.quantidade = tt-saldo-lote.quantidade - bf2-rat-lote.quantidade.
    
                 END.
            END.
    
            assign tt-saldo-lote.quantidade = tt-saldo-lote.quantidade - rowObject.quantidade.
    
        	if tt-saldo-lote.quantidade < 0 then do:
              {method/svc/errors/inserr.i
               &ErrorNumber="52368"  
               &ErrorType="EMS"
               &ErrorSubType="ERROR"
               &ErrorParameters="string(rowObject.quantidade) + '~~~~' + string(rowObject.lote)"}           
    	   
        	end.		
        END.
        else if item-doc-est.nro-comp <> "" then do:
            if can-find(funcao where 
                        funcao.cd-funcao = "spp-bloqueia-lote-devol" no-lock) then do:
    
                run utp/ut-msgs.p (input "msg":U, input 52369, input "":u).
    
                create RowErrors.
                assign RowErrors.ErrorNumber      = 52369
                       RowErrors.ErrorDescription = return-value
                       RowErrors.ErrorSubtype     = "ERROR":U.
    
            end.
            else do:
    
                    {method/svc/errors/inserr.i
                            &ErrorNumber="52369"  
                            &ErrorType="EMS"
                            &ErrorSubType="WARNING"
                            &ErrorParameters="string(rowObject.lote)"}
            end.
        end.

    END.


    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnLabelConc DBOProgram 
PROCEDURE returnLabelConc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    DEF INPUT  PARAM p-it-codigo   LIKE rat-lote.it-codigo NO-UNDO.
    DEF OUTPUT PARAM p-lb-per-ppm  AS CHARACTER            NO-UNDO.

    RUN findItem (p-it-codigo).

    &IF DEFINED(bf_man_per_ppm) &THEN 
        IF  AVAIL ITEM THEN DO:
            IF  item.tipo-formula = 2 THEN
                ASSIGN p-lb-per-ppm = "Conc".
            ELSE IF item.tipo-formula = 3 THEN
                ASSIGN p-lb-per-ppm = "PPM".
            ELSE ASSIGN p-lb-per-ppm = "Conc/PPM".
        END.
        ELSE ASSIGN p-lb-per-ppm = "Conc/PPM".
    &ENDIF
   
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-indice DBOProgram 
PROCEDURE pi-calc-indice :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param piDepositoCQ  as log   no-undo.

	
    FIND FIRST item-fornec-estab
        WHERE item-fornec-estab.it-codigo    = item.it-codigo 
        and   item-fornec-estab.cod-emitente = docum-est.cod-emitente
        AND   item-fornec-estab.cod-estabel  = docum-est.cod-estabel exclusive-lock NO-ERROR.

    if   AVAIL item-fornec-estab 
    AND item-fornec-estab.tp-inspecao > 3 then do:
        ASSIGN i-ind = item-fornec-estab.tp-inspecao - 3.
		&if '{&bf_lote_avancado_liberado}' = 'yes' &then
			IF l-lote-avancado THEN DO:
				FIND fda-param-inspec-fornec WHERE fda-param-inspec-fornec.cdn-emit = docum-est.cod-emitente NO-LOCK NO-ERROR .		
				IF AVAIL fda-param-inspec-fornec THEN DO:
					CASE item.criticidade:
						WHEN 1 THEN do:
                            CASE i-ind:
                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-1.
                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-2.
                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-x-3.
                            END CASE.
                            
                        END.
						WHEN 2 THEN do:
                            CASE i-ind:
                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-1.
                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-2.
                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-y-3.
                            END CASE.
                        end. 
						WHEN 3 THEN DO:
                            CASE i-ind:
                                WHEN 1 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-1.
                                WHEN 2 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-2.
                                WHEN 3 THEN assign i-indice-cq = fda-param-inspec-fornec.cdn-inspec-preferen-z-3.
                            END CASE.
                        END.
						OTHERWISE   assign i-indice-cq = 0.
					END CASE.
					ASSIGN i-tp-skip-lote-aux = fda-param-inspec-fornec.idi-tip-skip-lote.
				END.
				ELSE DO:
					FIND emitente WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK NO-ERROR.
					FIND fda-param-inspec WHERE fda-param-inspec.cdn-grp-emit = emitente.cod-gr-forn NO-LOCK NO-ERROR.
					IF AVAIL fda-param-inspec THEN DO:
						CASE item.criticidade:
							WHEN 1 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-x-3.
                                END CASE.
                            END.
    						WHEN 2 THEN do:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-y-3.
                                END CASE.
                            end. 
    						WHEN 3 THEN DO:
                                CASE i-ind:
                                    WHEN 1 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-1.
                                    WHEN 2 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-2.
                                    WHEN 3 THEN assign i-indice-cq = fda-param-inspec.cdn-inspec-preferen-z-3.
                                END CASE.
                            END.
							OTHERWISE   assign i-indice-cq = 0.
						END CASE.
						ASSIGN i-tp-skip-lote-aux = fda-param-inspec.idi-tip-skip-lote.
					END.
					ELSE DO:
						CASE item.criticidade:
							WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
							WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
							WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
							OTHERWISE   assign i-indice-cq = 0.
						END CASE.
						ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
					END.
				END.
			END.
			ELSE DO:
				CASE item.criticidade:
					WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
					WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
					WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
					OTHERWISE   assign i-indice-cq = 0.
				END CASE.
				ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
			END.
		&ELSE
			CASE item.criticidade:
				WHEN 1 THEN assign i-indice-cq = param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3].
				WHEN 2 THEN assign i-indice-cq = param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3].
				WHEN 3 THEN assign i-indice-cq = param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3].
				OTHERWISE   assign i-indice-cq = 0.
			END CASE.
			ASSIGN i-tp-skip-lote-aux = param-cq.tp-skip-lot.
		&ENDIF
		if  i-tp-skip-lote-aux = 1 then
			assign piDepositoCQ = ( random(0,100) <= i-indice-cq ).
		else do:
			 assign piDepositoCQ = no.
			 
			 if  i-indice-cq <= item-fornec-estab.niv-inspecao then 
				 assign piDepositoCQ             = yes
						item-fornec-estab.niv-inspecao = 0.
		end.
		if  not piDepositoCQ then 
			assign item-fornec-estab.niv-inspecao = item-fornec-estab.niv-inspecao + 1.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getValuesItemMatEstab DBOProgram 
PROCEDURE getValuesItemMatEstab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes: Retorna percentual e limite de variaá∆o cadastrado para o item. 
------------------------------------------------------------------------------*/

    def output param de-var-perc-vl   as decimal no-undo.
    def output param de-var-lim-vl    as decimal no-undo.
    def output param de-var-perc-qt   as decimal no-undo.
    def output param de-var-lim-qt    as decimal no-undo.
    

    for first item-uni-estab
        fields ( it-codigo   var-val-re-maior
                 var-qtd-re  lim-var-valor
                 cod-estabel lim-var-qtd    )
        where item-uni-estab.it-codigo   = item-doc-est.it-codigo
          and item-uni-estab.cod-estabel = docum-est.cod-estabel no-lock.
        
    end.
    
    if  not avail item-uni-estab
    or (     avail item-uni-estab 
        and (   item-uni-estab.var-val-re-maior = 0
             or item-uni-estab.lim-var-valor    = 0
             or item-uni-estab.var-qtd-re       = 0
             or item-uni-estab.lim-var-qtd      = 0 ) ) then do:

        for first item-mat
            fields ( it-codigo      var-val-re-maior
                     lim-var-valor  var-qtd-re     
                     lim-var-qtd                     ) 
            where item-mat.it-codigo = item-doc-est.it-codigo no-lock.
        end.
    end.


    assign de-var-perc-vl  = if  avail item-uni-estab
                             and item-uni-estab.var-val-re-maior > 0 
                             then item-uni-estab.var-val-re-maior
                             else item-mat.var-val-re-maior

           de-var-lim-vl   = if  avail item-uni-estab
                             and item-uni-estab.lim-var-valor > 0 
                             then item-uni-estab.lim-var-valor
                             else item-mat.lim-var-valor

           de-var-perc-qt  = if  avail item-uni-estab
                             and item-uni-estab.var-qtd-re > 0 
                             then item-uni-estab.var-qtd-re
                             else item-mat.var-qtd-re
                                 
           de-var-lim-qt   = if  avail item-uni-estab
                             and item-uni-estab.lim-var-qtd > 0 
                             then item-uni-estab.lim-var-qtd
                             else item-mat.lim-var-qtd.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateVariationValue DBOProgram 
PROCEDURE validateVariationValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pnum-ordem     AS INT       NO-UNDO.
    DEF INPUT PARAM p-qtd          AS DECIMAL   NO-UNDO.
    DEF INPUT PARAM de-preco-total AS DECIMAL   NO-UNDO.
    DEF INPUT PARAM de-preco-unit  AS DECIMAL   NO-UNDO.
    
    def var de-preuni        as decimal no-undo.
    def var de-taxa          as decimal no-undo.
    DEF VAR de-percentual-vl AS DECIMAL NO-UNDO.
    DEF VAR de-limite-vl     AS DECIMAL NO-UNDO.                     
    DEF VAR de-percentual-qt AS DECIMAL NO-UNDO.                
    DEF VAR de-limite-qt     AS DECIMAL NO-UNDO.
    DEF VAR de-var-max-perc  AS DECIMAL NO-UNDO.
    DEF VAR de-var-max-lim   AS DECIMAL NO-UNDO.
    DEF VAR l-erro           AS LOGICAL NO-UNDO.
    DEF VAR de-desconto      AS DECIMAL NO-UNDO.
        
    IF c-tipo = "UPDATE" THEN DO:
        
        FIND FIRST param-re 
             WHERE param-re.usuario = c-seg-usuario NO-LOCK NO-ERROR.
    
        FIND FIRST ordem-compra
             WHERE ordem-compra.numero-ordem = pnum-ordem NO-LOCK NO-ERROR.
        IF NOT AVAIL ordem-compra THEN 
            RETURN "nok":U.
        
    
        run findDocumento ( RowObject.cod-emitente,
                            RowObject.serie-docto,
                            RowObject.nro-docto,
                            RowObject.nat-operacao ).
        if  return-value <> "OK":U then
            return "NOK":U.                         
    
        run rep/re1908.p (input rowid(ordem-compra),
                          input docum-est.dt-emissao,
                          output de-preco-unit,
                          output de-desconto,
                          output de-taxa).
    
        assign de-preuni = (de-preco-total - de-desconto) / p-qtd
               de-preuni = if de-preuni = ? then 1 else de-preuni.
    
        run getValuesItemMatEstab ( output de-percentual-vl,
                                    output de-limite-vl,
                                    output de-percentual-qt,
                                    output de-limite-qt ).                  
    
         assign de-var-max-perc = round(de-preco-unit +
                                   (de-preco-unit * de-percentual-vl / 100), 2)
                de-var-max-lim = round((de-preco-unit + de-limite-vl), 2).
    
        assign l-erro = no.          
        if  de-percentual-vl = 0
        and de-limite-vl = 0 then do:
            if  de-preuni > de-var-max-perc
            or  de-preuni > de-var-max-lim THEN
                assign l-erro = yes.    
        end.        
        else DO:
            if  de-preuni <=  de-var-max-perc 
            or  de-percentual-vl = 0 then DO:
                if  de-preuni > de-var-max-lim  
                and de-limite-vl <> 0 then  DO:
                    assign l-erro = yes. 
                    
                END.
                
                else  
                    assign l-erro = no. 
            END.
            else
                assign l-erro = yes. 
        END.
            
        if  l-erro then do:
            IF  param-re.aceita-var = no then do:                               
                {method/svc/errors/inserr.i
                                   &ErrorNumber="15241"  /*Preªo da ordem de compra excede variaªío permitida.*/
                                   &ErrorType="EMS"
                                   &ErrorSubType="ERROR"}
                RETURN "NOK":U.
                
            END.
            ELSE do:
                {method/svc/errors/inserr.i
                                   &ErrorNumber="15242"  /*Preªo da ordem de compra excede variaªío permitida*/
                                   &ErrorType="EMS"
                                   &ErrorSubType="WARNING"}
                RETURN "NOK":U.
            END.
        END.
    END.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRatLotFDA DBOProgram 
procedure createRatLotFDA:
    def input-output param table for tt-rat-lote-fda.
    
    def var l-deposito-cq   as logical no-undo.
    def var l-amostragem    as  log no-undo.
    def var c-depos-cq like rat-lote.cod-depos no-undo.
    def var de-tam-amostra  as decimal no-undo.
    def var i-tipoSimul     as int no-undo.
    def var l-baixa-estoque as log no-undo.
    def var i-origem        as int no-undo.
    def var h-cqapi304fx    as handle no-undo.
    DEF VAR c-cod-lote      AS CHARACTER   NO-UNDO.
    DEF VAR dt-valid-lote   AS DATE NO-UNDO.
    DEF VAR l-sugere-lote   AS LOGICAL NO-UNDO.
    
    def buffer bf-tt-rat-lote for tt-rat-lote-fda.
    
    &if '{&bf_lote_avancado_liberado}' = 'yes' &then
    if can-find (first funcao 
                 where funcao.cd-funcao = "LOTE-AVANCADO":U
                   and funcao.ativo = yes) then do:

        FIND FIRST tt-rat-lote-fda NO-ERROR.
        IF AVAIL tt-rat-lote-fda THEN DO:
            IF NOT AVAIL param-global THEN
                FOR FIRST param-global FIELDS(modulo-cq) NO-LOCK: END.
            RUN findItemDocumento (input tt-rat-lote-fda.cod-emitente,
                                   input tt-rat-lote-fda.serie-docto,
                                   input tt-rat-lote-fda.nro-docto,
                                   input tt-rat-lote-fda.nat-operacao,
                                   INPUT tt-rat-lote-fda.sequencia).

            RUN findDocumento (input tt-rat-lote-fda.cod-emitente,
                               input tt-rat-lote-fda.serie-docto,
                               input tt-rat-lote-fda.nro-docto,
                               input tt-rat-lote-fda.nat-operacao).
            RUN findNatureza (INPUT tt-rat-lote-fda.nat-operacao).
            RUN findParamCQ.
            run findItem      ( input tt-rat-lote-fda.it-codigo ).
            run findItemUniEstab ( input tt-rat-lote-fda.it-codigo,
                                   input docum-est.cod-estabel ).
            if  natur-oper.tipo = 1
                and not natur-oper.terceiros 
                or  (    natur-oper.tp-oper-terc <> 1
                     and natur-oper.tp-oper-terc <> 2 ) then 
            
                if  param-global.modulo-cq          /* Possui modulo CQ */
                and param-cq.tipo-cq > 1            /* SΩ Gera Roteiro ou CQ Total */
                and not natur-oper.transf           /* Nao e Transferencia */
                and avail item-uni-estab
                and item-uni-estab.contr-qualid               /* Item possui CQ */
                and item.it-codigo <> " " then do:  /* Item deve ser codificado */ 
                    run getDepositoCQ ( output l-deposito-cq ).
                end.     
                    
            if l-deposito-cq and (item.tipo-con-est = 3 or item.tipo-con-est = 4) then do:
                {cqp/cq0824.i item.it-codigo item.fm-codigo docum-est.cod-estabel} /*Consulta dos par≥metros do FDA*/
                if avail fda-lote-param-espcif then
                   assign l-amostragem = fda-lote-param-espcif.log-amostra.
                else
                   IF AVAIL fda-lote-param THEN
                        assign l-amostragem = fda-lote-param.log-amostra.
                
                if l-amostragem then do:
                   run piBuscaBaixaEstoque(output i-origem,
                                           output l-baixa-estoque).
                   run cqp/cqapi304fx.p persistent set h-cqapi304fx.
                   run getExams IN h-cqapi304fx (input docum-est.cod-estabel,
                                                 input tt-rat-lote-fda.it-codigo,
                                                 input docum-est.cod-emitente,
                                                 input tt-rat-lote-fda.quantidade,
                                                 input i-origem,
                                                 input l-baixa-estoque,
                                                 input item-doc-est.op-codigo,
                                                 input item-doc-est.nr-ord-produ,
                                                 output table ttCQSimulationVO,
                                                 output table RowErrors).
                    
                   IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
                        RETURN "NOK":U.
                   for each ttCQSimulationVO:
                       assign de-tam-amostra = de-tam-amostra + ttCQSimulationVO.sampleSize.
                   end.           
                   if de-tam-amostra > 0 then do:
                        run buscaDepositoCQ (output c-depos-cq).
                        if tt-rat-lote-fda.cod-depos = c-depos-cq OR de-tam-amostra >= tt-rat-lote-fda.quantidade then DO:
                            ASSIGN tt-rat-lote-fda.cod-depos = c-depos-cq.
                        END.
                        ELSE DO:
                             assign tt-rat-lote-fda.quantidade = tt-rat-lote-fda.quantidade - de-tam-amostra.
                          
                             create bf-tt-rat-lote.
                             buffer-copy tt-rat-lote-fda except cod-localiz to bf-tt-rat-lote no-error.
                             
                             find first localizacao 
                                  where localizacao.cod-estabel = docum-est.cod-estabel
                                    and localizacao.cod-depos   = c-depos-cq no-lock no-error.
                             if avail localizacao then
                                assign bf-tt-rat-lote.cod-localiz = localizacao.cod-localiz.

                             assign bf-tt-rat-lote.cod-depos = c-depos-cq
                                    bf-tt-rat-lote.quantidade = de-tam-amostra
                                    bf-tt-rat-lote.cod-lote-orig = tt-rat-lote-fda.lote. 

                             EMPTY TEMP-TABLE tt-dados-fda.
                             create tt-dados-fda.
                             assign tt-dados-fda.cod-estabel     = docum-est.cod-estabel   
                                    tt-dados-fda.it-codigo       = bf-tt-rat-lote.it-codigo
                                    tt-dados-fda.cod-refer       = bf-tt-rat-lote.cod-refer
                                    tt-dados-fda.cod-modul-dtsul = "MRE"
                                    tt-dados-fda.cod-usuario     = c-seg-usuario
                                    tt-dados-fda.cod-depos       = bf-tt-rat-lote.cod-depos
                                    tt-dados-fda.cod-localiz     = bf-tt-rat-lote.cod-localiz
                                    tt-dados-fda.fm-codigo       = item.fm-codigo WHEN AVAIL ITEM.

                             RUN buscaLoteFda (INPUT TABLE tt-dados-fda,
                                               OUTPUT c-cod-lote,
                                               OUTPUT dt-valid-lote,
                                               OUTPUT l-sugere-lote).
                            
                            IF c-cod-lote = "" THEN DO:
                                {utp/ut-liter.i "Lote da amostra deve ser diferente de Branco. Verifique no CD0024 se h† regra cadastrada para numeraá∆o do lote da amostra."}
                                ASSIGN c-lb-msg = RETURN-VALUE.
                                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR" 
                                                            &ErrorParameters=c-lb-msg}
                            END.
                            IF dt-valid-lote = ? THEN DO:
                                {utp/ut-liter.i "Data Validade do Lote da amostra deve ser informada. Verifique no CD0024 se h† regra cadastrada para data de validade do lote da amostra."}
                                ASSIGN c-lb-msg = RETURN-VALUE.
                                {method/svc/errors/inserr.i &ErrorNumber="17006"
                                                            &ErrorType="EMS"
                                                            &ErrorSubType="ERROR" 
                                                            &ErrorParameters=c-lb-msg}
                            END.                   
                            ASSIGN bf-tt-rat-lote.lote = c-cod-lote
                                   bf-tt-rat-lote.dt-vali-lote = dt-valid-lote. 

                        end.
                   end.
                   ELSE
                       run buscaDepositoCQ (output tt-rat-lote-fda.cod-depos).
                end.
            end.
        END.
    end.
    &endif       
    if valid-handle(h-cqapi304fx) then do:
        DELETE PROCEDURE h-cqapi304fx.
        assign h-cqapi304fx = ?.                
    end. 
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.
 RETURN "OK":U.
end procedure.  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryOfComponente DBOProgram 
PROCEDURE openQueryOfComponente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QueryName}
        FOR EACH  {&TableName} NO-LOCK
            WHERE {&TableName}.serie-docto  = c-serie-docto
            AND   {&TableName}.nro-docto    = c-nro-docto
            AND   {&TableName}.cod-emitente = i-cod-emitente
            AND   {&TableName}.nat-operacao = c-nat-operacao
            AND   {&TableName}.it-codigo    = c-it-codigo
            AND   {&TableName}.cod-refer    = c-cod-refer
            AND   {&TableName}.sequencia    = i-sequencia
        INDEXED-REPOSITION.
    
    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaBaixaEstoque DBOProgram 
procedure piBuscaBaixaEstoque:

   def output param pi-origem as int no-undo.
   def output param pl-baixa-estoque as log no-undo.
   
   def var l-nao-inspec-autom as log no-undo.
   def var i-op-seq as int no-undo.
   def var i-origem-req as int no-undo.
   def var l-faz-cq as log no-undo.
   def var l-item-doc as log no-undo.
   def var l-oper-triang as log no-undo.
   def var i-ord-prod like item-doc-est.nr-ord-produ no-undo.
   
   DEF BUFFER b-natur-oper FOR natur-oper.
   if can-find(first funcao 
               where funcao.cd-funcao = "spp-cq-nao-insp":U
                 and funcao.ativo     = yes) then
       assign l-nao-inspec-autom = yes.
   else
       assign l-nao-inspec-autom = no.
   
   
   assign l-faz-cq   = yes
          pi-origem   = 2
          l-item-doc = no
          i-ord-prod  = item-doc-est.nr-ord-produ.
   
   if  item-doc-est.it-codigo = "" then
       assign l-faz-cq = no
              pi-origem = 1.
   
   &if  defined(bf_mat_oper_triangular) &then
        
        if  avail natur-oper
        and natur-oper.log-oper-triang then do:
   
            for first b-natur-oper
                where b-natur-oper.nat-operacao = natur-oper.nat-vinculada no-lock:
            end.
   
            if  avail b-natur-oper
            and b-natur-oper.tipo = 2
            and b-natur-oper.terceiros
            and (   b-natur-oper.tp-oper-terc = 1
                 or b-natur-oper.tp-oper-terc = 3 ) then
                    assign l-oper-triang = yes.
            else
                assign l-oper-triang = no.
        end.
        if  l-oper-triang then
            assign pi-origem = 1. /* Manual */
   
   &endif
   
   if  item-doc-est.conta-contabil <> "":U 
   and item.tipo-contr             <> 1
   and i-ord-prod                  = 0  then
       assign pi-origem   = 2  /* Estoque */
              l-item-doc = yes. 
   
   if  i-ord-prod <> 0 
   or  (item-doc-est.it-codigo  <> "" and item.tipo-contr  = 4) then do:
        if  l-nao-inspec-autom then
            assign l-faz-cq = yes.
        else 
            assign l-faz-cq = no.
   
       /*-- Quando nío inspeciona automaticamente
            a origem serˇ sempre manual --*/
       if  l-faz-cq then
           assign pi-origem = 1. /* Manual */
       else     
          if  i-ord-prod <> 0 then
              assign pi-origem = 3. /* Producao */
          else
              assign pi-origem = 2. /* Estoque */
   end.
   
   find FIRST ord-prod 
       where ord-prod.nr-ord-produ = item-doc-est.nr-ord-produ no-lock no-error.
   
   if  avail ord-prod then do:        
       find FIRST reservas
           where reservas.nr-ord-produ = ord-prod.nr-ord-produ
             and reservas.it-codigo   = item-doc-est.it-codigo
             and reservas.item-pai    = item-doc-est.item-pai
             and reservas.cod-roteiro = item-doc-est.cod-roteiro
             and reservas.op-codigo   = item-doc-est.op-codigo
          no-lock no-error.
   
       if  not avail reservas 
       and ( item-doc-est.item-pai    = " " or item-doc-est.item-pai = "0" )
       and ( item-doc-est.cod-roteiro = " " or trim(item-doc-est.cod-roteiro) = "0" )
       and item-doc-est.op-codigo   = 0  then 
           find first reservas 
                where reservas.nr-ord-produ = ord-prod.nr-ord-produ
                  and reservas.it-codigo   = item-doc-est.it-codigo 
                no-lock no-error.
   
       assign i-origem-req = if  avail reservas then reservas.int-1 
                             else ord-prod.int-1.
   
       if ord-prod.rep-prod = 1 or ord-prod.rep-prod = 4 then assign i-op-seq = 0.
       else do:
         if avail reservas then do:
            find first oper-ord 
                 where oper-ord.nr-ord-produ = reservas.nr-ord-produ
                   and oper-ord.cod-roteiro = reservas.cod-roteiro
                   and oper-ord.op-codigo   = reservas.op-codigo no-lock no-error.
            if avail oper-ord then assign i-op-seq = oper-ord.sequencia.
            else do:
                find last oper-ord 
                    where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
                if avail oper-ord then assign i-op-seq = oper-ord.sequencia.
                else assign i-op-seq = 0.
            end.
         end.
         else assign i-op-seq = 0.
       end.
   end.
   else 
       assign i-origem-req = 1.    
       
   assign pl-baixa-estoque = if (i-origem-req = 1 or i-origem-req = 3)
                                 and (i-ord-prod <> 0 or item.tipo-contr = 4) 
                                 then not(l-faz-cq)
                                 else 
                                 if (l-oper-triang or l-item-doc) then no
                                 else yes.                                      

end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDepositoCQ DBOProgram 
procedure buscaDepositoCQ:
    def output param c-cod-depos-cq like rat-lote.cod-depos no-undo.
    DEF VAR h-cdapi024 AS HANDLE NO-UNDO.

    &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
       DEFINE VARIABLE c-unid-neg-aux AS CHARACTER  NO-UNDO.

       if not valid-handle(h-cdapi024) 
           or h-cdapi024:type <> "PROCEDURE"
           or h-cdapi024:file-name <> "cdp/cdapi024.p" then do:
           run cdp/cdapi024.p persistent set h-cdapi024.
       end.
    
       /*Se a UN n∆o foi informada no item do documento,
       buscar† unidade de neg¢cio do relacionamento ITEM X ESTABELECIMENTO X DEP‡SITO,
       se n∆o existir, retornar† UN do relacionamento ITEM X ESTABELECIMENTO. */
       if item-doc-est.cod-unid-negoc = "" then do:
    
           if valid-handle(h-cdapi024) then 
               run RetornaUnidadeNegocioExternaliz in h-cdapi024 (input docum-est.cod-estabel,
                                                                  input item-doc-est.it-codigo,
                                                                  input item-doc-est.cod-depos,
                                                                  output c-unid-neg-aux).
       end.
       else
           assign c-unid-neg-aux = item-doc-est.cod-unid-negoc.
    
       /*Relacionamento entre UN e Estabel, para determinaá∆o dos dep¢sitos,
       se n∆o encontrar, utilizar† o dep¢sito informado para o estabelecimento*/
       IF NOT AVAIL estabelec OR estabelec.cod-estabel <> docum-est.cod-estabel THEN
           FIND FIRST estabelec WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
       find first unid-negoc-cq
           where unid-negoc-cq.cod-estabel    = docum-est.cod-estabel
           and   unid-negoc-cq.cod-unid-negoc = c-unid-neg-aux no-lock no-error.
       if avail unid-negoc-cq then
           assign c-cod-depos-cq = unid-negoc-cq.cod-depos-cq.
       else
           assign c-cod-depos-cq = estabelec.deposito-cq.
    &else
       assign c-cod-depos-cq = estabelec.deposito-cq.
    &endif
    
    if valid-handle(h-cdapi024) then do:
        delete procedure h-cdapi024.
        assign h-cdapi024 = ?.
    end.
end procedure.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createRatLot DBOProgram 
PROCEDURE createRatLot:
    DEF INPUT PARAM TABLE FOR tt-rat-lote-fda.
    FOR EACH tt-rat-lote-fda:
        CREATE bfrat-lote.
        BUFFER-COPY tt-rat-lote-fda TO bfrat-lote NO-ERROR.
    END.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaLoteFda DBOProgram 
PROCEDURE buscaLoteFda:
    DEFINE INPUT  PARAM TABLE FOR tt-dados-fda.
    DEFINE OUTPUT PARAM c-cod-lote    AS CHAR NO-UNDO.
    DEFINE OUTPUT PARAM dt-valid-lote AS DATE NO-UNDO.
    DEFINE OUTPUT PARAM l-sugere-lote  AS LOGICAL NO-UNDO.

    DEFINE VARIABLE h-ceapi030     AS HANDLE      NO-UNDO.
    define variable l-amostra      as log         no-undo.
    define variable i-tp-amostra   as int         no-undo.
    
    empty temp-table tt-valores.
    empty temp-table tt-erro.
    
    IF NOT VALID-HANDLE(h-ceapi030) THEN
        RUN cep/ceapi030.p PERSISTENT SET h-ceapi030(input table tt-dados-fda,
                                                     output table tt-valores, 
                                                     output table tt-erro).   
    RUN pi-executar IN h-ceapi030 (input table tt-dados-fda,
                                   output table tt-valores,
                                   output table tt-erro). 
    FIND FIRST tt-dados-fda NO-ERROR.
    IF AVAIL tt-dados-fda THEN
        run pi-param-esp in h-ceapi030 (input tt-dados-fda.it-codigo,
                                        input "",
                                        input tt-dados-fda.cod-estabel,
                                        output l-sugere-lote,
                                        output l-amostra,
                                        output i-tp-amostra).
    
     FOR FIRST tt-valores:
        ASSIGN c-cod-lote    = tt-valores.lote
               dt-valid-lote = tt-valores.dt-val.
     END.
     
    IF CAN-FIND (FIRST tt-erro) THEN
       RUN cdp/cd0666.w (INPUT TABLE tt-erro).
    IF VALID-HANDLE (h-ceapi030) THEN DO:
        DELETE PROCEDURE h-ceapi030.
        ASSIGN h-ceapi030 = ?.
    END.
    
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ENDIF

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-engine-deposito DBOProgram 
PROCEDURE pi-engine-deposito :
/*------------------------------------------------------------------------------
  Purpose:     retornar o dep¢sito e localizaá∆o do engine de regras
  Parameters:  dep¢sito e localizaá∆o
------------------------------------------------------------------------------*/

    DEFINE INPUT-OUTPUT PARAMETER p-cod-depos   LIKE rat-lote.cod-depos   NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER p-cod-localiz LIKE rat-lote.cod-localiz NO-UNDO.

    DEFINE VARIABLE c-estabel     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-chave-docto AS CHARACTER NO-UNDO.

    IF NOT AVAIL docum-est THEN DO:
        FIND FIRST docum-est NO-LOCK
            WHERE docum-est.cod-emitente = RowObject.cod-emitente
              AND docum-est.serie-docto  = RowObject.serie-docto
              AND docum-est.nro-docto    = RowObject.nro-docto
              AND docum-est.nat-operacao = RowObject.nat-operacao NO-ERROR.
    END.

    if  not avail docum-est then 
        FIND FIRST doc-fisico NO-LOCK
            WHERE doc-fisico.cod-emitente = RowObject.cod-emitente
            AND   doc-fisico.serie-docto  = RowObject.serie-docto
            AND   doc-fisico.nro-docto    = RowObject.nro-docto
            AND   doc-fisico.tipo-nota    = RowObject.tipo-nota NO-ERROR.

    IF  AVAIL docum-est
    AND docum-est.origem = "XML":U THEN
        return "NOK":U.

    IF  AVAIL doc-fisico
    AND doc-fisico.origem = "XML":U THEN
        return "NOK":U.

    if  not avail docum-est 
    and not avail doc-fisico then 
        return "NOK":U.

    ASSIGN c-estabel = if avail docum-est then docum-est.cod-estabel
                       else doc-fisico.cod-estabel.

    FOR FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = c-estabel:
    END.

    IF NOT CAN-FIND(FIRST config-operac no-lock
                    WHERE config-operac.cdn-empresa    = estabelec.ep-codigo
                      AND config-operac.cod-estab      = estabelec.cod-estabel
                      AND config-operac.cod-tip-operac = "RE-Deposito-localiz":U) THEN RETURN "NOK":U.

    RUN pi-carrega-var-engine (OUTPUT TABLE tt-variavel).
    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    IF NOT VALID-HANDLE(h-cdapi034) THEN
        RUN cdp/cdapi034.p PERSISTENT SET h-cdapi034 (INPUT estabelec.ep-codigo,
                                                      INPUT estabelec.cod-estabel,
                                                      INPUT "RE-Deposito-localiz":U,
                                                      INPUT TABLE tt-variavel,
                                                      OUTPUT i-cod-regra-utilizada,
                                                      OUTPUT TABLE tt-retorno,
                                                      OUTPUT TABLE RowErrors APPEND).

    ASSIGN c-chave-docto = STRING(RowObject.cod-emitente) + "|" + RowObject.serie-docto + "|" + RowObject.nro-docto + "|" + RowObject.nat-operacao + "|" + STRING(RowObject.sequencia).
    
    RUN set-constraint-log-execucao IN h-cdapi034(INPUT c-chave-docto,
                                                  INPUT RowObject.sequencia, /*seq item*/
                                                  INPUT "":U,                /*conteudo original*/
                                                  INPUT 0).                  /*tipo documento (NFe)*/

    RUN pi-inicializa IN h-cdapi034 (INPUT estabelec.ep-codigo,
                                     INPUT estabelec.cod-estabel,
                                     INPUT "RE-Deposito-localiz":U,
                                     INPUT TABLE tt-variavel,
                                     OUTPUT i-cod-regra-utilizada,
                                     OUTPUT TABLE tt-retorno,
                                     OUTPUT TABLE RowErrors APPEND).

    if  valid-handle (h-cdapi034) then do:
        delete procedure h-cdapi034.
        assign h-cdapi034 = ?.
    end.

    FOR EACH RowErrors EXCLUSIVE-LOCK
        WHERE RowErrors.ErrorNumber = 25997:
        DELETE RowErrors.
    END.
    IF  CAN-FIND(FIRST RowErrors NO-LOCK
                 WHERE RowErrors.ErrorSubType = "ERROR") THEN
        RETURN "NOK":U.

    /*passa os retornos do engine para as variaveis apropriadas*/
    FOR EACH tt-retorno:

        IF  tt-retorno.campo-retorno = "cod-depos":U then 
            ASSIGN p-cod-depos = tt-retorno.valor-retorno.

        IF  tt-retorno.campo-retorno = "cod-localiz":U THEN
            ASSIGN p-cod-localiz = tt-retorno.valor-retorno.
    END.

    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-var-engine DBOProgram 
PROCEDURE pi-carrega-var-engine:
    DEFINE OUTPUT PARAMETER TABLE FOR tt-variavel.

    DEFINE BUFFER bNnaturFisc FOR natur-oper.

    EMPTY TEMP-TABLE tt-variavel.

    IF NOT AVAIL RowObject THEN RETURN "NOK".

    /*Carrega variaveis para o engine de regras*/

    /*Conjunto variaveis Emitente*/
    
    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper   = "cod-emitente":U
           tt-variavel.valor-variavel = STRING(RowObject.cod-emitente).

    /*Conjunto variaveis Documento*/

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper   = "tipo-nota":U
           tt-variavel.valor-variavel = STRING(RowObject.tipo-nota).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper   = "nat-operacao":U
           tt-variavel.valor-variavel = STRING(RowObject.nat-operacao).

    CREATE tt-variavel.
    ASSIGN tt-variavel.cod-var-oper   = "serie-Docto":U
           tt-variavel.valor-variavel = STRING(RowObject.serie-docto).

    if  avail docum-est then do:
        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "cod-estabel":U
               tt-variavel.valor-variavel = STRING(docum-est.cod-estabel).

        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "cod-observacao":U
               tt-variavel.valor-variavel = STRING(docum-est.observacao).

        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "data-emissao":U
               tt-variavel.valor-variavel = STRING(docum-est.dt-emissao).

        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "data-trans":U
               tt-variavel.valor-variavel = STRING(docum-est.dt-trans).

        run findItemDocumento (RowObject.cod-emitente,
                               RowObject.serie-docto,  
                               RowObject.nro-docto,    
                               RowObject.nat-operacao, 
                               RowObject.sequencia).   

        if  avail item-doc-est then do:
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper   = "it-codigo":U
                   tt-variavel.valor-variavel = STRING(item-doc-est.it-codigo).

            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper   = "nat-of":U
                   tt-variavel.valor-variavel = STRING(item-doc-est.nat-of).

            /*Conjunto variaveis Natureza Operacao*/

            FOR FIRST bNnaturFisc WHERE bNnaturFisc.nat-operacao = item-doc-est.nat-of NO-LOCK. END.

            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "cod-cfop":U
                   tt-variavel.valor-variavel    = bNnaturFisc.cod-cfop.
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "tipo-compra":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.tipo-compra).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "especie-doc":U
                   tt-variavel.valor-variavel    = bNnaturFisc.especie-doc.
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "modelo-eletr":U
                   tt-variavel.valor-variavel    = bNnaturFisc.cod-model-nf-eletro.
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-transf":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.transf).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-terceiros":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.terceiros).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "tipo-oper-terc":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.tp-oper-terc).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-gera-nf-fat":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.imp-nota).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-nf-rateio":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.nota-rateio).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-nf-propria":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.ind-nota-propria = 1).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-nf-comercio":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.log-2).
            
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper      = "log-compra-ativo":U
                   tt-variavel.valor-variavel    = STRING(bNnaturFisc.venda-ativo).

        end.            
    end.
    else 
    if  avail doc-fisico then do:
        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "cod-estabel":U
               tt-variavel.valor-variavel = STRING(doc-fisico.cod-estabel).
               
        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "data-emissao":U
               tt-variavel.valor-variavel = STRING(doc-fisico.dt-emissao).

        CREATE tt-variavel.
        ASSIGN tt-variavel.cod-var-oper   = "data-trans":U
               tt-variavel.valor-variavel = STRING(doc-fisico.dt-trans).

        FIND FIRST it-doc-fisico use-index documento 
            where it-doc-fisico.serie-docto  = doc-fisico.serie-docto 
            and   it-doc-fisico.nro-docto    = doc-fisico.nro-docto 
            and   it-doc-fisico.cod-emitente = doc-fisico.cod-emitente 
            and   it-doc-fisico.tipo-nota    = doc-fisico.tipo-nota 
            and   it-doc-fisico.sequencia    = RowObject.sequencia no-lock no-error.
        IF  AVAIL it-doc-fisico THEN DO:
            CREATE tt-variavel.
            ASSIGN tt-variavel.cod-var-oper   = "it-codigo":U
                   tt-variavel.valor-variavel = STRING(it-doc-fisico.it-codigo).
        END.
    end.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecutaEngine DBOProgram 
PROCEDURE setExecutaEngine:
    DEFINE INPUT PARAMETER pl-executa-engine AS LOG NO-UNDO.

    ASSIGN l-executa-engine = pl-executa-engine.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
