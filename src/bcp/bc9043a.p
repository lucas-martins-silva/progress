/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9043A 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9043a MBC}
&ENDIF




{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then
    /* Definicao global do nome da transacao */
    &global-define ProgramName BC9043
    &global-define TempTable tt-separa-packing
    {bcp/bc9043.i " "}
    {utp/utapi009.i} /* login */
    {utp/ut-glob.i}                
    {bcp/bc9015.i3}  /* def variaveis padroes */
    {method/dbotterr.i}

    DEFINE TEMP-TABLE ttpedidos NO-UNDO
        FIELD embarque   LIKE wms-box-packing.cdd-embarq
        FIELD resumo     LIKE wms-box-packing.nr-resumo
        FIELD pedido     LIKE wms-box-packing.nr-pedcli
        FIELD nome-abrev LIKE wms-box-packing.nome-abrev.
    
    DEFINE INPUT PARAM TABLE FOR ttpedidos.
    DEFINE OUTPUT PARAM p-embarque   AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAM p-resumo     AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM p-pedido     AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM p-nome-abrev AS CHARACTER NO-UNDO.

    DEFINE  QUERY qry-ttpedidos FOR ttpedidos.
    DEFINE BROWSE brw-ttpedidos 
            QUERY qry-ttpedidos NO-LOCK
          DISPLAY ttpedidos.pedido
                  ttpedidos.nome-abrev 
                  WITH NO-BOX No-labels SIZE 20 BY 3.5 NO-SCROLLBAR-VERTICAL.
    
    /* Variaveis de trabalho */              
    DEFINE VARIABLE vLogOk            AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE VARIABLE de-embarque       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>9':U NO-UNDO.
    DEFINE VARIABLE i-cod-resumo      AS INTEGER   FORMAT '>>>>,>>9':U         NO-UNDO.
    DEFINE VARIABLE i-p-embarque      AS INTEGER   FORMAT '>>>>>9':U           NO-UNDO.
    DEFINE VARIABLE i-p-cod-resumo    AS INTEGER   FORMAT '>>>>,>>9':U         NO-UNDO.
    DEFINE VARIABLE c-pedcli          AS CHARACTER                             NO-UNDO.
    DEFINE VARIABLE c-nome-abrev      AS CHARACTER                             NO-UNDO.
    
    /* Propriedades globais para frames */  
    &global-define ErrorDisplaySeconds 3
    &global-define FrameSize    20 By 8
    
    /***************************************** Frames Inicio ******************************************/
    /* Definicao da Frame01 */
    &global-define Frame01Name   Frame01
    &global-define Frame01Defs   'Pedidos do Embarque'                              At Row 01 Col 01          ~
                                 '--------------------'                             At Row 02 Col 01          ~
                                 brw-ttpedidos                                      At Row 03 Col 01          ~
                                 'Emb:'                                             AT ROW 07 COL 01          ~
                                 de-embarque                                        AT ROW 07 COL 05 No-label ~
                                 'Resumo:'                                          AT ROW 08 COL 01          ~
                                 i-cod-resumo                                       AT ROW 08 COL 08 NO-LABEL
    &global-define Frame01Repeat NO
    &global-define Update01Fields brw-ttpedidos
    &global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
    &global-define TriggerAfterFrame01  Run GravaCamposFrame01.
    /* Definicao das trigger de usuario ---                     */ 
    &global-define UserTriggers                                 ~
        ON 'ESC':U OF brw-ttpedidos IN FRAME {&Frame01Name} DO: ~
            IF vLogFinaliza = YES THEN DO:                      ~
                ASSIGN  p-embarque   = i-p-embarque             ~
                        p-resumo     = i-p-cod-resumo           ~
                        p-pedido     = c-pedcli                 ~
                        p-nome-abrev = c-nome-abrev.            ~
            END. ~
            ELSE DO:                                            ~
                ASSIGN p-embarque   = 0                         ~
                       p-resumo     = 0                         ~
                       p-pedido     = ""                        ~
                       p-nome-abrev = "".                       ~
            END.                                                ~
            HIDE ALL.                                           ~
        END.                                                    ~
        ON 'value-changed':U OF brw-ttpedidos DO:               ~
           ASSIGN   de-embarque    :SCREEN-VALUE IN FRAME {&frame01name} = string(ttpedidos.embarque) ~
                    i-cod-resumo  :SCREEN-VALUE IN FRAME {&frame01name} = string(ttpedidos.resumo)  ~
                    i-p-embarque   = ttpedidos.embarque                             ~
                    i-p-cod-resumo = ttpedidos.resumo                               ~
                    c-pedcli       = ttpedidos.pedido                               ~
                    c-nome-abrev   = ttpedidos.nome-abrev.                          ~
        END.                                                                            ~
        ON 'enter':U OF brw-ttpedidos IN FRAME {&Frame01Name} DO:                       ~
            ASSIGN  vLogSai       = YES                                                 ~
                    vLogFinaliza  = YES.                                                ~
            APPLY 'ESC':U TO  brw-ttpedidos IN FRAME {&Frame01Name}.                    ~
        END.

    {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
    
    PROCEDURE InicializaCamposFrame01:
        IF vLogFinaliza = YES THEN DO:
            ASSIGN vLogSai      = YES      
                   vLogFinaliza = YES.
            HIDE ALL NO-PAUSE.
            RETURN RETURN-VALUE.
        END.

        OPEN QUERY qry-ttpedidos
          FOR EACH ttpedidos NO-LOCK
                BY ttpedidos.resumo.
        
        APPLY 'value-changed':U TO brw-ttpedidos IN FRAME {&frame01name}.
    END PROCEDURE.
&else 
    RUN  utp/ut-msgs.p (INPUT "show", 
                        INPUT 28036,
                        INPUT "").
&endif

