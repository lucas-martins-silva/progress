/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9045B 2.00.00.003 } /*** "010003" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9045b MBC}
&ENDIF                              

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then

    /* Definicao global do nome da transacao */
    &global-define ProgramName BC9045
    &global-define TempTable tt-conf-rec-fisico
    {bcp/bc9045.i " "}
    {utp/utapi009.i} /* login */
    {utp/ut-glob.i}                
    {bcp/bc9015.i3}  /* def variaveis padroes */
    {method/dbotterr.i}                         

    DEFINE INPUT PARAM p-cod-usuario      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pcod-coletor       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pcod-equipamento   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-nro-docto        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-serie            AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-tipo-nota        AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM p-emitente         AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM p-id-carga         AS DECIMAL   NO-UNDO.
    DEFINE OUTPUT PARAM p-finaliza        AS LOGICAL   NO-UNDO.

    DEFINE TEMP-TABLE ttWork NO-UNDO
        FIELD cod-usuario      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Usuario'         
        FIELD cod-coletor      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Coletor'      INITIAL ""
        FIELD cod-equipamento  AS CHARACTER FORMAT 'x(14)':U           LABEL 'Equipamento'  INITIAL ""
        FIELD num-serial       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>':U  LABEL 'Etiqueta'
        FIELD qtd-conf         AS DECIMAL   FORMAT '>>>>>,>>9.9999':U  LABEL 'Qtd'.
    CREATE ttWork.
    ASSIGN ttWork.cod-usuario        = p-cod-usuario
           ttWork.cod-coletor        = pcod-coletor
           ttWork.cod-equipamento    = pcod-equipamento.

    DEFINE TEMP-TABLE ttWm-etiqueta NO-UNDO LIKE wm-etiqueta
        FIELD RowNum AS INTEGER INIT 1
        field r-Rowid as rowid.
    
    /* Variaveis de trabalho */              
    DEFINE VARIABLE vLogOk            AS LOGICAL   INITIAL NO     NO-UNDO.
    DEFINE VARIABLE c-mensagem        AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE vNomeUsuario      AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE cod-refer         AS CHARACTER                NO-UNDO.
    DEFINE VARIABLE ind-sit-agrupador AS INTEGER                  NO-UNDO.
    DEFINE VARIABLE log-confer        AS LOGICAL                  NO-UNDO.
    DEFINE VARIABLE id-carga-etiq     AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE i-quantidade      AS DECIMAL                  NO-UNDO.
    DEFINE VARIABLE c-item            AS CHARACTER FORMAT 'x(16)' NO-UNDO.
    DEFINE VARIABLE c-lote            AS CHARACTER FORMAT 'x(40)' NO-UNDO.
    DEFINE VARIABLE i-seq-item        AS INTEGER                  NO-UNDO.
    
    DEFINE NEW SHARED VARIABLE wgbosc074 AS WIDGET-HANDLE NO-UNDO.    
    
    /* Propriedades globais para frames */              
    &global-define ErrorDisplaySeconds 3
    &global-define FrameSize    20 By 8
    
    /***************************************** Frames Inicio ******************************************/
    /* Definicao da Frame01 */
    &global-define Frame01Name   Frame01
    &global-define Frame01Defs   'Conf. Rec. F°sico   '                             At Row 01    Col 01     ~
                                 '--------------------'                             At Row 02    Col 01     ~
                                 'Etiqueta:'                                        AT ROW 03    COL 01          ~
                                 ttwork.num-serial                                  At Row 04    Col 01 NO-LABEL ~
                                 'Qtd:'                                             AT ROW 05    COL 01          ~
                                 ttwork.qtd-conf                                    AT ROW 05    COL 05 NO-LABEL ~
                                 'Item:'                                            AT ROW 06    COL 01          ~
                                 c-item                                             AT ROW 06    COL 06 NO-LABEL FORMAT "x(16)" VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                                 'Lt:'                                              AT ROW 07    COL 01          ~
                                 c-lote                                             AT ROW 07    COL 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                                 'Encerra: 777777'                                  AT ROW 08    COL 01          ~
    &global-define Frame01Repeat NO
    
    /* Definicao da Frame02 ---                                 */
    &global-define Frame02Name   Frame02
    &global-define Frame02Defs   {&Frame01Defs}
    &global-define Frame02Repeat NO
                                        
    &global-define Update01Fields ttwork.num-serial
    &global-define Update02Fields ttwork.qtd-conf WHEN ind-sit-agrupador = 1 

    /* Definicao das trigger de interacao com a tela */ 
    &global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01.
    &global-define TriggerAfterFrame01  RUN GravaCamposFrame01. 
    &global-define TriggerBeforeFrame02 RUN InicializaCamposFrame02.
    &global-define TriggerAfterFrame02  RUN GravaCamposFrame02. IF vLogSai = YES THEN DO:           ~
                                                                  ASSIGN ttwork.num-serial = 0      ~
                                                                         ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01  = '0'. ~
                                                                  HIDE ALL NO-PAUSE.                                             ~
                                                                END.                                                             ~
                                                                IF vLogFinaliza = YES THEN DO:       ~
                                                                   ASSIGN vLogSai        = YES       ~
                                                                          ttwork.num-serial = 0      ~
                                                                          ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01  = '0' ~
                                                                          p-finaliza = YES.                                      ~
                                                                   HIDE ALL NO-PAUSE.                                            ~
                                                                END.
    /* Definicao das trigger de usuario  */ 
    &global-define UserTriggers                                                                     ~
                                ON 'ESC':U OF Frame Frame01                                         ~
                                DO:                                                                 ~
                                   ASSIGN p-finaliza = YES                                          ~
                                          vLogSai    = YES                                          ~
                                          vLogFinaliza = YES.                                       ~
                                   HIDE ALL.                                                        ~
                                END.                                                                ~
                                ON 'leave':U OF ttwork.num-serial IN Frame Frame01                  ~
                                DO:                                                                 ~
                                    ASSIGN INPUT FRAME Frame01 ttwork.num-serial.                   ~
                                    IF ttWork.num-serial <> 777777 THEN DO:                         ~
                                         RUN gotokey         IN wgbosc074(INPUT ttWork.num-serial).      ~
                                         IF RETURN-VALUE = 'OK':U THEN DO:                               ~
                                             RUN getCharField IN wgbosc074(INPUT "cod-item",             ~
                                                                           OUTPUT c-item).               ~
                                             RUN getCharField IN wgbosc074(INPUT "cod-lote",             ~
                                                                           OUTPUT c-lote).               ~
                                             RUN getDecField IN wgbosc074(INPUT "qtd-item",              ~
                                                                      OUTPUT ttwork.qtd-conf).           ~
                                             RUN getIntField IN wgbosc074(INPUT "ind-sit-agrupador",     ~
                                                                          OUTPUT ind-sit-agrupador).     ~
                                             RUN getIntField IN wgbosc074(INPUT "seq-item",              ~
                                                                          OUTPUT i-seq-item).            ~
                                             DISP c-item                                                 ~
                                                  c-lote                                                 ~
                                                  ttwork.qtd-conf WITH FRAME frame01.                    ~
                                         END.                                                            ~
                                    END.                                                                 ~
                                END.

      /* Definicao dos objetos ativos */ 
    &global-define ActiveObject1 wgbosc074
    
    {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
    {bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
    
    PROCEDURE InicializaCamposFrame01:
        IF vLogSai  THEN DO:
            ASSIGN vLogSai      = YES      
                   vLogFinaliza = YES.
            HIDE ALL NO-PAUSE.
            RETURN RETURN-VALUE.
        END.
    
        ASSIGN vLogErro  = NO.
    
        IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
            RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
            RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR. 
        END.

        ASSIGN ttWork.num-serial      = 0
               ttwork.qtd-conf        = 0  
               c-item                 = ''
               c-lote                 = ''
               ind-sit-agrupador      = 0
               cod-refer              = ''
               i-seq-item             = 0. 

        DISP ttWork.num-serial ttwork.qtd-conf c-item c-lote WITH FRAME Frame01. 
        APPLY 'leave':U TO ttWork.num-serial IN FRAME Frame01.
    END PROCEDURE.

    PROCEDURE InicializaCamposFrame02:
        ASSIGN vLogErro     = NO 
               vLogSai      = NO 
               vLogFinaliza = NO.

        DISP ttWork.num-serial 
             ttWork.qtd-conf
             c-item
             c-lote WITH FRAME frame02.
    END PROCEDURE.
    
    PROCEDURE GravaCamposFrame01:
        ASSIGN vLogErro = NO 
               vLogOk   = NO 
               vLogFinaliza = NO
               vLogSai      = NO
               INPUT FRAME Frame01 ttWork.num-serial 
                                   ttwork.qtd-conf  
                                   c-item 
                                   c-lote.
        IF ttWork.num-serial <> 777777 THEN DO:
            /*Valida Etiqueta de Packing*/
            RUN gotokey         IN wgbosc074(INPUT ttWork.num-serial).        
            IF RETURN-VALUE = 'NOK':U THEN DO:
                ASSIGN vLogErro = Yes.
                {bcp/bc9105.i "301" "Etiqueta n∆o cadastrada."}
                RETURN ERROR.
            END.
            
            RUN getCharField IN wgbosc074(INPUT "cod-item",
                                          OUTPUT c-item).
            RUN getCharField IN wgbosc074(INPUT "cod-lote",
                                          OUTPUT c-lote).
            RUN getDecField IN wgbosc074(INPUT "qtd-item",
                                         OUTPUT ttwork.qtd-conf).
            RUN getDecField IN wgbosc074(INPUT "id-carga",
                                         OUTPUT id-carga-etiq).  
            RUN getCharField IN wgbosc074(INPUT "cod-refer",
                                          OUTPUT cod-refer).
            RUN getIntField IN wgbosc074(INPUT "seq-item", 
                                         OUTPUT i-seq-item).
            DISP c-item c-lote WITH FRAME Frame01. 

            IF id-carga-etiq <> p-id-carga THEN DO:
                ASSIGN vLogErro = Yes.
                {bcp/bc9105.i "302" "Etiqueta n∆o pertence ao documento informado."}
                RETURN ERROR.
            END.
            
            RUN getLogField IN wgbosc074(INPUT "log-confer",
                                         OUTPUT log-confer).
            IF log-confer = YES THEN DO:
                ASSIGN vLogErro = Yes.
                {bcp/bc9105.i "302" "Etiqueta j† est† conferida."}
                RETURN ERROR.
            END.
            
            RUN getIntField IN wgbosc074(INPUT "ind-sit-agrupador",
                                         OUTPUT ind-sit-agrupador).
            IF ind-sit-agrupador = 2 /*Agrupador Etiquetas*/ THEN DO:
                ASSIGN vLogErro = Yes.
                {bcp/bc9105.i "302" "Etiqueta tipo agrupadora de etiquetas n∆o pode ser lida na conferància."}
                RETURN ERROR.
            END.
        END.
    END PROCEDURE.

    PROCEDURE GravaCamposFrame02:
        ASSIGN vLogErro     = NO 
               vLogSai      = NO 
               vLogFinaliza = NO.
        IF ttWork.num-serial <> 777777 THEN DO:
            IF ind-sit-agrupador = 1 THEN DO:
                IF ttwork.qtd-conf = 0 THEN DO:
                    ASSIGN vLogErro = Yes.
                    {bcp/bc9105.i "303" "Quantidade inv†lida."}
                    RETURN ERROR.
                END.
                RUN gotokey   IN wgbosc074(INPUT ttWork.num-serial).        
                RUN getRecord IN wgbosc074(OUTPUT TABLE ttWm-etiqueta).
                FIND FIRST ttWm-etiqueta NO-ERROR. 
                ASSIGN ttWm-etiqueta.qtd-item = ttwork.qtd-conf.
                RUN emptyRowErrors IN wgbosc074.
                RUN setRecord      IN wgbosc074 (INPUT TABLE ttWm-etiqueta).
                RUN updateRecord   IN wgbosc074.
                IF RETURN-VALUE <> "OK":U THEN DO:
                    RUN getRowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
                    ASSIGN vLogErro = YES.
                    FOR EACH RowErrors:
                        ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                        {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
                    END.
                    RETURN ERROR.
                END.
            END.
            /*Grava quantidade conferida*/
            EMPTY TEMP-TABLE tt-conf-rec-fisico. 
            CREATE tt-conf-rec-fisico.
            ASSIGN tt-conf-rec-fisico.cod-usuario     = ttWork.cod-usuario                 
                   tt-conf-rec-fisico.cod-coletor     = ttWork.cod-coletor                 
                   tt-conf-rec-fisico.cod-equipamento = ttWork.cod-equipamento             
                   tt-conf-rec-fisico.nro-docto       = p-nro-docto                                        
                   tt-conf-rec-fisico.serie           = p-serie                                            
                   tt-conf-rec-fisico.tipo-nota       = p-tipo-nota                                        
                   tt-conf-rec-fisico.emitente        = p-emitente                                        
                   tt-conf-rec-fisico.num-serial      = ttWork.num-serial                               
                   tt-conf-rec-fisico.it-codigo       = c-item
                   tt-conf-rec-fisico.lote            = c-lote
                   tt-conf-rec-fisico.cod-refer       = cod-refer
                   tt-conf-rec-fisico.quant-conf      = ttwork.qtd-conf
                   tt-conf-rec-fisico.id-carga        = p-id-carga 
                   tt-conf-rec-fisico.ind-fim-conf    = NO
                   tt-conf-rec-fisico.seq-item        = i-seq-item. 
            RUN GravaTransacao.
            ASSIGN vLogSai = YES.
        END.
        ELSE DO:
            EMPTY TEMP-TABLE tt-conf-rec-fisico. 
            CREATE tt-conf-rec-fisico.
            ASSIGN tt-conf-rec-fisico.cod-usuario     = ttWork.cod-usuario                 
                   tt-conf-rec-fisico.cod-coletor     = ttWork.cod-coletor                 
                   tt-conf-rec-fisico.cod-equipamento = ttWork.cod-equipamento             
                   tt-conf-rec-fisico.nro-docto       = p-nro-docto                                        
                   tt-conf-rec-fisico.serie           = p-serie                                            
                   tt-conf-rec-fisico.tipo-nota       = p-tipo-nota                                        
                   tt-conf-rec-fisico.emitente        = p-emitente                                        
                   tt-conf-rec-fisico.num-serial      = 0                                     
                   tt-conf-rec-fisico.it-codigo       = ''
                   tt-conf-rec-fisico.seq-item        = 0
                   tt-conf-rec-fisico.lote            = ''
                   tt-conf-rec-fisico.cod-refer       = ''
                   tt-conf-rec-fisico.quant-conf      = 0
                   tt-conf-rec-fisico.id-carga        = p-id-carga 
                   tt-conf-rec-fisico.ind-fim-conf    = YES. 
            RUN GravaTransacao.
            ASSIGN vLogFinaliza           = YES.
        END.
    END PROCEDURE.
    
    PROCEDURE GravaTransacao:
        ASSIGN vTransDetail = VTransaction   +
                              " Serial: "     +  STRING({&TempTable}.num-serial).
    
        RUN _RetornaUsuario (OUTPUT vNomeUsuario).
    
        ASSIGN {&TempTable}.dat-atualizacao         = TODAY 
               {&TempTable}.dat-transacao           = TODAY 
               {&TempTable}.cod-usuario             = vNomeUsuario.
    
        RAW-TRANSFER {&TempTable} TO vConteudoRaw.
    
        FOR EACH tt-erro-after-GenerateDC:
            DELETE tt-erro-after-GenerateDC.
        END.
        
        RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                                    INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                    INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                    INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */
    
        FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.
    
        IF AVAIL tt-erro-after-GenerateDC THEN DO:
            RUN bcp/bc9115.p (tt-erro-after-GenerateDC.cd-erro,tt-erro-after-GenerateDC.mensagem,8,20,3).
            HIDE ALL.
            RETURN "NOK":U.
        END.
        ELSE DO:
            ASSIGN c-mensagem = "Conferància da etiqueta: " + STRING({&TempTable}.num-serial) + " efetuado com sucesso".
            RUN bcp/bc9115.p ("0", c-mensagem,8,20,3).
            HIDE ALL.
            RETURN "OK":U.
        END.  
    END  PROCEDURE.
&else 
    RUN  utp/ut-msgs.p (INPUT "show", 
                        INPUT 28036,
                        INPUT "").
&endif
