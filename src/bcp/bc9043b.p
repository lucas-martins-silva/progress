/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9043B 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9043b MBC}
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

    DEFINE TEMP-TABLE ttbox-armazenados NO-UNDO
        FIELD cod-estabel            LIKE wms-box-packing.cod-estabel  
        FIELD cod-local              LIKE wms-box-packing.cod-local
        FIELD cdd-embarq             LIKE wms-box-packing.cdd-embarq
        FIELD nr-resumo              LIKE wms-box-packing.nr-resumo
        FIELD nr-pedcli              LIKE wms-box-packing.nr-pedcli
        FIELD nome-abrev             LIKE wms-box-packing.nome-abrev
        FIELD id-box                 LIKE wms-box-packing.id-box
        FIELD bloco                  LIKE wms-box-espera.cod-bloco
        FIELD rua                    LIKE wms-box-espera.cod-rua
        FIELD nivel                  LIKE wms-box-espera.cod-nivel
        FIELD coluna                 LIKE wms-box-espera.cod-coluna
        FIELD lado                   LIKE wms-box-espera.ind-posicao-box
        FIELD total-vol-box          AS INTEGER
        FIELD total-vol-separado-box AS INTEGER.

    DEFINE INPUT PARAM p-embarque         AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAM p-resumo           AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM p-pedido           AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-nome-abrev       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR ttbox-armazenados.
    DEFINE INPUT PARAM p-qtd-vol-total    AS INTEGER NO-UNDO.
    DEFINE INPUT PARAM p-qtd-vol-separado AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAM p-id-box          AS DECIMAL NO-UNDO.
    DEFINE OUTPUT PARAM p-retornou-esc    AS LOGICAL NO-UNDO.

    DEFINE TEMP-TABLE tt-enderecos NO-UNDO
        FIELD id-box            AS DECIMAL   FORMAT '>>>>>>>>>9':U    
        FIELD endereco          AS CHAR      FORMAT 'x(17)':U
        FIELD volumes-separados AS INTEGER
        FIELD volumes-total     AS INTEGER.

    DEFINE  QUERY qry-ttenderecos FOR tt-enderecos.
    DEFINE BROWSE brw-ttenderecos 
            QUERY qry-ttenderecos NO-LOCK
          DISPLAY tt-enderecos.endereco
                  WITH NO-BOX No-labels SIZE 20 BY 3.5 NO-SCROLLBAR-VERTICAL.
    
    /* Variaveis de trabalho */              
    DEFINE VARIABLE vLogOk              AS LOGICAL   INITIAL NO            NO-UNDO.
    DEFINE VARIABLE c-volumes           AS CHARACTER FORMAT 'x(10)':U      NO-UNDO.
    DEFINE VARIABLE i-volumes-separados AS INTEGER                         NO-UNDO.
    DEFINE VARIABLE i-volumes-total     AS INTEGER                         NO-UNDO.
    DEFINE VARIABLE selec-box           AS DECIMAL   FORMAT '>>>>>>>>>9':U NO-UNDO.
    DEFINE VARIABLE v-pos-box           AS CHARACTER FORMAT 'x(1)':U       NO-UNDO.

    /* Propriedades globais para frames */  
    &global-define ErrorDisplaySeconds 3
    &global-define FrameSize    20 By 8
    
    /***************************************** Frames Inicio ******************************************/
    /* Definicao da Frame01 */
    &global-define Frame01Name   Frame01
    &global-define Frame01Defs   'Separa‡Æo Packing'                                At Row 01 Col 01          ~
                                 '--------------------'                             At Row 02 Col 01          ~
                                 brw-ttenderecos                                    At Row 03 Col 01          ~
                                 'Volumes:'                                         AT ROW 08 COL 01          ~
                                 c-volumes                                          AT ROW 08 COL 09 No-label ~
    &global-define Frame01Repeat NO
    &global-define Update01Fields brw-ttenderecos
    &global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
    &global-define TriggerAfterFrame01  Run GravaCamposFrame01.
    /* Definicao das trigger de usuario ---                     */ 
    &global-define UserTriggers                                   ~
        ON 'ESC':U OF brw-ttenderecos IN FRAME {&Frame01Name} DO: ~
            IF vLogFinaliza = YES THEN DO:                        ~
                ASSIGN  p-retornou-esc   = NO                     ~
                        p-id-box         = selec-box.             ~
            END.                                                  ~
            ELSE DO:                                              ~
                ASSIGN p-retornou-esc   = YES                     ~
                       p-id-box         = 0.                      ~
            END.                                                  ~
            APPLY 'F4' TO brw-ttenderecos IN FRAME {&Frame01Name}.                         ~
        END.                                                      ~
        ON 'value-changed':U OF brw-ttenderecos DO:                                                                ~
           ASSIGN c-volumes:SCREEN-VALUE IN FRAME {&frame01name} = STRING(tt-enderecos.volumes-separados) + "/" +  ~
                                                                   STRING(tt-enderecos.volumes-total)              ~
                  selec-box       = tt-enderecos.id-box.                                                           ~
        END.                                                                                                       ~
        ON 'enter':U OF brw-ttenderecos IN FRAME {&Frame01Name} DO:                                                ~
           ASSIGN  vLogSai       = YES                                                                             ~
                   vLogFinaliza  = YES.                                                                            ~
           APPLY 'ESC':U TO  brw-ttenderecos IN FRAME {&Frame01Name}.                                              ~
        END.

    {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
    
    PROCEDURE InicializaCamposFrame01:
        IF vLogFinaliza = YES THEN DO:
            ASSIGN vLogSai      = YES      
                   vLogFinaliza = YES.
            HIDE ALL NO-PAUSE.
            RETURN RETURN-VALUE.
        END.

        FOR EACH ttbox-armazenados:
            IF ttbox-armazenados.lado = 1 THEN
                ASSIGN v-pos-box = "E".
            ELSE
                ASSIGN v-pos-box = "D".
            
            CREATE tt-enderecos.
            ASSIGN tt-enderecos.id-box            = ttbox-armazenados.id-box
                   tt-enderecos.endereco          = ttbox-armazenados.bloco  + "/":U + ttbox-armazenados.rua    + "/":U +  
                                                    ttbox-armazenados.nivel  + "/":U + ttbox-armazenados.coluna + "/":U + v-pos-box
                   tt-enderecos.volumes-separados = p-qtd-vol-separado 
                   tt-enderecos.volumes-total     = p-qtd-vol-total.
        END.

        OPEN QUERY qry-ttenderecos
          FOR EACH tt-enderecos NO-LOCK
                BY tt-enderecos.id-box.

        ASSIGN c-volumes:SCREEN-VALUE IN FRAME {&frame01name} = STRING(tt-enderecos.volumes-separados) + "/" + 
                                                                   STRING(tt-enderecos.volumes-total)
               selec-box       = tt-enderecos.id-box. 

        
        /*APPLY 'value-changed':U TO brw-ttenderecos IN FRAME {&frame01name}.*/
    END PROCEDURE.
&else 
    RUN  utp/ut-msgs.p (INPUT "show", 
                        INPUT 28036,
                        INPUT "").
&endif
