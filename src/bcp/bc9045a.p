/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9045A 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9045a MBC}
&ENDIF                                   

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then
    /* Definicao global do nome da transacao */
    &global-define ProgramName BC9045
    &global-define TempTable tt-conf-rec-fisico
    {bcp/bc9045.i " "}
    {utp/utapi009.i} /* login */
    {utp/ut-glob.i}                
    {bcp/bc9015.i3}  /* def variaveis padroes */
    {method/dbotterr.i}

    DEFINE TEMP-TABLE tt-fornec-docto NO-UNDO
        FIELD nro-docto        AS CHARACTER FORMAT "x(16)":U
        FIELD serie            AS CHARACTER FORMAT "X(05)":U
        FIELD cod-emitente     AS INTEGER   FORMAT ">>>>>>>>9":U
        FIELD tipo-nota        AS INTEGER   FORMAT ">9":U
        FIELD nome-abrev       AS CHARACTER FORMAT "x(12)":U
        FIELD data-transacao   AS DATE.
    
    DEFINE INPUT  PARAM TABLE FOR tt-fornec-docto.
    DEFINE OUTPUT PARAM p-cod-emitente  AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM p-tipo-nota     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM p-nome-abrev    AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM p-dt-trans      AS DATE      NO-UNDO.

    DEFINE  QUERY qry-ttfornec FOR tt-fornec-docto.
    DEFINE BROWSE brw-ttfornec 
            QUERY qry-ttfornec NO-LOCK
          DISPLAY tt-fornec-docto.cod-emitente
                  tt-fornec-docto.nome-abrev 
                  WITH NO-BOX No-labels SIZE 20 BY 6 NO-SCROLLBAR-VERTICAL.
    
    /* Variaveis de trabalho */              
    DEFINE VARIABLE vLogOk            AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE i-emitente        AS INTEGER   FORMAT '>>>>>>>>9':U NO-UNDO.
    DEFINE VARIABLE i-tipo-nota       AS INTEGER   FORMAT '>9':U        NO-UNDO.
    DEFINE VARIABLE c-nome-abrev      AS CHARACTER                      NO-UNDO.
    DEFINE VARIABLE dt-trans          AS DATE                           NO-UNDO.
    
    /* Propriedades globais para frames */  
    &global-define ErrorDisplaySeconds 3
    &global-define FrameSize    20 By 8
    
    /***************************************** Frames Inicio ******************************************/
    /* Definicao da Frame01 */
    &global-define Frame01Name   Frame01
    &global-define Frame01Defs   'Conf. Rec. F¡sico   '                             At Row 01 Col 01     ~
                                 '--------------------'                             At Row 02 Col 01     ~
                                 brw-ttfornec                                       At Row 03 Col 01
                                 
    &global-define Frame01Repeat NO
    &global-define Update01Fields brw-ttfornec
    &global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
    &global-define TriggerAfterFrame01  Run GravaCamposFrame01.
    /* Definicao das trigger de usuario ---                     */ 
    &global-define UserTriggers                                 ~
        ON 'ESC':U OF brw-ttfornec IN FRAME {&Frame01Name} DO: ~
            IF vLogFinaliza = YES THEN DO:                      ~
                ASSIGN p-cod-emitente  = i-emitente             ~
                       p-tipo-nota     = i-tipo-nota            ~
                       p-nome-abrev    = c-nome-abrev           ~
                       p-dt-trans      = dt-trans.              ~
            END. ~
            ELSE DO:                                            ~
                ASSIGN p-cod-emitente = 0                       ~
                       p-tipo-nota    = 0                       ~
                       p-nome-abrev   = "".                     ~
            END.                                                ~
            HIDE ALL.                                           ~
        END.                                                    ~
        ON 'value-changed':U OF brw-ttfornec DO:               ~
            ASSIGN  i-emitente    = tt-fornec-docto.cod-emitente                           ~
                    i-tipo-nota   = tt-fornec-docto.tipo-nota                              ~
                    c-nome-abrev  = tt-fornec-docto.nome-abrev                             ~
                    dt-trans      = tt-fornec-docto.data-transacao.                        ~
        END.                                                                               ~
        ON 'enter':U OF brw-ttfornec IN FRAME {&Frame01Name} DO:                           ~
            ASSIGN  vLogSai       = YES                                                    ~
                    vLogFinaliza  = YES.                                                   ~
            APPLY 'ESC':U TO  brw-ttfornec IN FRAME {&Frame01Name}.                        ~
        END.

    {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
    
    PROCEDURE InicializaCamposFrame01:
        IF vLogFinaliza = YES THEN DO:
            ASSIGN vLogSai      = YES      
                   vLogFinaliza = YES.
            HIDE ALL NO-PAUSE.
            RETURN RETURN-VALUE.
        END.

        OPEN QUERY qry-ttfornec
          FOR EACH tt-fornec-docto NO-LOCK.
        
        APPLY 'value-changed':U TO brw-ttfornec IN FRAME {&frame01name}.
    END PROCEDURE.
&else 
    RUN  utp/ut-msgs.p (INPUT "show", 
                        INPUT 28036,
                        INPUT "").
&endif

