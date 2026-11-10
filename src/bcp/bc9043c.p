/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9043C 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9043c MBC}
&ENDIF




{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
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

    DEFINE INPUT PARAM p-cod-usuario      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pcod-coletor       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pcod-equipamento   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-embarque         AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAM p-resumo           AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM p-pedido           AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-nome-abrev       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM p-id-box           AS DECIMAL   NO-UNDO.
    DEFINE INPUT PARAM TABLE FOR ttbox-armazenados.

    DEFINE TEMP-TABLE ttWork NO-UNDO
        FIELD cod-usuario      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Usuario'         
        FIELD cod-coletor      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Coletor'      INITIAL ""
        FIELD cod-equipamento  AS CHARACTER FORMAT 'x(14)':U           LABEL 'Equipamento'  INITIAL ""
        FIELD num-serial       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>':U LABEL 'Serial Lido'
        FIELD num-box          AS DECIMAL   FORMAT '>>>>>>>>>9':U      LABEL 'Box Armazenamento'.
    CREATE ttWork.
    ASSIGN ttWork.cod-usuario        = p-cod-usuario
           ttWork.cod-coletor        = pcod-coletor
           ttWork.cod-equipamento    = pcod-equipamento.
    
    /* Variaveis de trabalho */ 
    DEFINE VARIABLE num-box-auxiliar  AS DECIMAL FORMAT '>>>>>>>>>9':U INITIAL 0 NO-UNDO.
    DEFINE VARIABLE vLogOk            AS LOGICAL   INITIAL NO                  NO-UNDO.
    DEFINE VARIABLE c-endereco        AS CHAR      FORMAT 'x(17)':U            NO-UNDO.
    DEFINE VARIABLE v-pos-box         AS CHAR                                  NO-UNDO.
    DEFINE VARIABLE c-mensagem        AS CHARACTER                             NO-UNDO.
    DEFINE VARIABLE vNomeUsuario      AS CHARACTER                             NO-UNDO.
    DEFINE VARIABLE de-embarque       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>9':U NO-UNDO.
    DEFINE VARIABLE i-pedcli          AS CHARACTER FORMAT 'X(12)':U            NO-UNDO.
    DEFINE VARIABLE c-volumes         AS CHARACTER FORMAT 'X(09)':U            NO-UNDO.
    DEFINE VARIABLE vNumCont          AS INTEGER   INITIAL 0                   NO-UNDO.
    DEFINE VARIABLE l-end-bloqueado   AS LOGICAL   INITIAL NO                  NO-UNDO.
    
    DEFINE NEW SHARED VARIABLE wgbosc169 AS WIDGET-HANDLE NO-UNDO.    
    DEFINE NEW SHARED VARIABLE wgbosc152 AS WIDGET-HANDLE NO-UNDO.    

    /* Propriedades globais para frames */              
    &global-define ErrorDisplaySeconds 3
    &global-define FrameSize    20 By 8
    
    /***************************************** Frames Inicio ******************************************/
    /* Definicao da Frame01 */
    &global-define Frame01Name   Frame01
    &global-define Frame01Defs   'Local Separaá∆o '                                 At Row 01    Col 01          ~
                                 'End.:'                                            AT ROW 02    COL 01          ~
                                 ttwork.num-box                                     At Row 02    Col 06 NO-LABEL ~
                                 'Packing:'                                         AT ROW 03    COL 01          ~
                                 ttwork.num-serial                                  At Row 04    Col 01 NO-LABEL ~
                                 c-endereco                                         AT ROW 05    COL 01 NO-LABEL ~
                                 'Emb:'                                             AT ROW 06    COL 01          ~
                                 de-embarque                                        AT ROW 06    COL 05 NO-LABEL ~
                                 'Ped:'                                             AT ROW 07    COL 01          ~
                                 i-pedcli                                           AT ROW 07    COL 05 NO-LABEL ~
                                 'Volumes:'                                         AT ROW 08    COL 01          ~
                                 c-volumes                                          AT ROW 08    COL 09 NO-LABEL

    &global-define Frame01Repeat YES
    &global-define Update01Fields ttwork.num-box     ~
                                  ttwork.num-serial

    /* Definicao das trigger de interacao com a tela */ 
    &global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01.
    &global-define TriggerAfterFrame01  RUN GravaCamposFrame01.  IF vLogFinaliza = YES THEN DO:         ~
                                                                   ASSIGN vLogSai        = YES          ~
                                                                          ttWork.num-box = 0            ~
                                                                          ttwork.num-serial = 0         ~
                                                                          ttWork.num-box:SCREEN-VALUE IN FRAME Frame01  = '0'  ~
                                                                          ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01  = '0'.  ~
                                                                END.
    /* Definicao das trigger de usuario  */ 
    &global-define UserTriggers                                                                     ~
                                ON 'ESC':U OF Frame Frame01 DO:                                     ~
                                    HIDE ALL.                                                       ~
                                END.                                                                ~
                                ON 'entry':U OF ttWork.num-box IN FRAME Frame01                     ~
                                DO:                                                                 ~
                                    IF num-box-auxiliar <> 0 THEN DO:                               ~
                                        APPLY 'leave':U TO ttWork.num-box IN FRAME Frame01.         ~
                                        RETURN NO-APPLY.                                            ~
                                    END.                                                            ~
                                END.

    /* Definicao dos objetos ativos */ 
    &global-define ActiveObject1 wgbosc169
    &global-define ActiveObject2 wgbosc152
    
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
        
        IF NOT VALID-HANDLE(wgbosc152)  THEN DO:
           Run scbo/bosc152.p Persistent SET wgbosc152.
           Run openQueryStatic In wgbosc152 (Input "Main":U) No-error. 
        END.        
        
        IF NOT VALID-HANDLE(wgbosc169)  THEN DO:
           RUN scbo/bosc169.p PERSISTENT SET wgbosc169.
           RUN openQueryStatic IN wgbosc169 (INPUT "Main":U) NO-ERROR. 
        END.               

        ASSIGN ttWork.num-box    = num-box-auxiliar
               ttWork.num-serial = 0
               c-endereco        = ""
               de-embarque       = p-embarque
               i-pedcli          = p-pedido
               c-volumes         = "". 
        FIND FIRST ttbox-armazenados EXCLUSIVE-LOCK
            WHERE ttbox-armazenados.id-box = p-id-box NO-ERROR.
        IF AVAIL ttbox-armazenados THEN DO:
            IF ttbox-armazenados.lado = 1 THEN                     
                ASSIGN v-pos-box = "E".                              
            ELSE                                                     
                ASSIGN v-pos-box = "D".                              
            
            ASSIGN c-endereco = ttbox-armazenados.bloco  + "/":U +         
                                ttbox-armazenados.rua    + "/":U +         
                                ttbox-armazenados.nivel  + "/":U +         
                                ttbox-armazenados.coluna + "/":U +         
                                v-pos-box                           
                   c-volumes =  STRING(ttbox-armazenados.total-vol-separado-box) + "/":U +
                                STRING(ttbox-armazenados.total-vol-box).
        END.
             
        DISP ttWork.num-box ttWork.num-serial c-endereco de-embarque i-pedcli c-volumes WITH FRAME Frame01. 
        APPLY 'leave':U TO ttWork.num-box IN FRAME Frame01.
        
    END PROCEDURE.
    
    PROCEDURE GravaCamposFrame01:
        ASSIGN vLogErro = NO 
               vLogOk   = NO 
               vLogFinaliza = NO
               vLogSai      = NO
               INPUT FRAME Frame01 ttWork.num-box 
                                   ttWork.num-serial 
                                   c-endereco 
                                   de-embarque 
                                   i-pedcli 
                                   c-volumes.
        IF ttWork.num-box <> p-id-box THEN DO:
           ASSIGN vLogErro = YES.
           {bcp/bc9105.i "402" "Endereáo Incorreto. (WMS)"}
            RETURN ERROR.
        END.
        
        /*Valida Etiqueta de Packing*/
        RUN openquerystatic IN wgbosc152(INPUT "main"). 
        RUN gotokey         IN wgbosc152(INPUT ttWork.num-serial).        
        IF RETURN-VALUE = 'NOK':U THEN DO:
            ASSIGN vLogErro = Yes
                   num-box-auxiliar = ttWork.num-box.
            {bcp/bc9105.i "403" "Etiqueta n∆o cadastrada."}
            RETURN ERROR.
        END.
        
        /*Valida Etiqueta j† Separada*/
        RUN validateEtiquetaSeparada IN wgbosc169(INPUT ttbox-armazenados.cod-estabel,      
                                                  INPUT ttbox-armazenados.cod-local,
                                                  INPUT ttwork.num-serial).
        If RETURN-VALUE <> 'OK':U THEN DO:
            ASSIGN vLogErro = Yes
                   num-box-auxiliar = ttWork.num-box.
            {bcp/bc9105.i "404" "Etiqueta j† separada."}
            RETURN ERROR.
        END.
        
        EMPTY TEMP-TABLE tt-separa-packing. 
        CREATE tt-separa-packing.
        ASSIGN tt-separa-packing.cod-usuario      = ttWork.cod-usuario     
               tt-separa-packing.cod-coletor      = ttWork.cod-coletor     
               tt-separa-packing.cod-equipamento  = ttWork.cod-equipamento 
               tt-separa-packing.num-serial       = ttwork.num-serial
               tt-separa-packing.num-box          = ttWork.num-box
               tt-separa-packing.cod-estabel      = ttbox-armazenados.cod-estabel
               tt-separa-packing.cod-local        = ttbox-armazenados.cod-local
               tt-separa-packing.cdd-embarq       = ttbox-armazenados.cdd-embarq
               tt-separa-packing.nr-resumo        = ttbox-armazenados.nr-resumo
               tt-separa-packing.nr-pedcli        = ttbox-armazenados.nr-pedcli
               tt-separa-packing.nome-abrev       = ttbox-armazenados.nome-abrev.
        RUN GravaTransacao.
        IF RETURN-VALUE = "OK":U THEN DO:
            ASSIGN ttbox-armazenados.total-vol-separado-box = ttbox-armazenados.total-vol-separado-box + 1
                   c-volumes = ""
                   c-volumes = STRING(ttbox-armazenados.total-vol-separado-box) + "/":U +
                               STRING(ttbox-armazenados.total-vol-box).
            DISP c-volumes WITH FRAME Frame01. 
        END.
        IF ttbox-armazenados.total-vol-separado-box = ttbox-armazenados.total-vol-box THEN DO:
            PAUSE 2 NO-MESSAGE.
            ASSIGN vLogFinaliza = YES.
        END.
        ELSE 
            ASSIGN num-box-auxiliar = ttWork.num-box.
        
    END PROCEDURE.
    
    PROCEDURE GravaTransacao:
        ASSIGN vTransDetail = VTransaction   +
                              " Serial: "     +  STRING({&TempTable}.num-serial) + 
                              " idBox: "      +  STRING({&TempTable}.num-box).
    
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
            ASSIGN c-mensagem = "Separaá∆o da etiqueta: " + STRING({&TempTable}.num-serial) + " efetuado com sucesso".
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
