/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPIWMS 2.00.00.007 } /*** "010007" 09/10/2025 11:26:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPIWMS MUT}
&ENDIF


{include/i_dbvers.i}
{include/i_dbinst.i}
&if '{&mgscm_version}' >= '2.04' &then
    /*------------------------------------------------------------------------ */
    /*     File: bcapiwms.p                                                    */
    /*     Purpose: Api with standart procedures for WMS                       */
    /*------------------------------------------------------------------------ */
    
    
    /* ***************************  Main Block  *************************** */
    
    
    /* ***************************   Includes   *************************** */
    {method/dbotterr.i}
    {bcp/bc9102.i}
    {utp/ut-glob.i}
    
    
    
    /* ***************************  Definitions  ************************** */
    
    DEFINE TEMP-TABLE ttwm-box NO-UNDO LIKE wm-box
        FIELD RowNum  AS INTEGER INIT 1 
        FIELD r-Rowid AS ROWID.         
    
    define temp-table tt-erros NO-UNDO
        field cod-erro  as integer
        field desc-erro as character format "x(256)"
        field desc-arq  as character.
    
    
    DEFINE VARIABLE i-cont              AS INTEGER    INITIAL 0       NO-UNDO.
    DEFINE VARIABLE v2_cod_usuar_corren AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE vLogControlaLogin   AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE vLogErro            AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE vLogUtilizaColetor  AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE vLogAtivo           AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE vLogProcesso        AS LOGICAL                    NO-UNDO.
    DEFINE VARIABLE c-cod-usuario       AS CHARACTER FORMAT 'x(25)':U NO-UNDO.
    DEFINE VARIABLE c-cod-dominio       AS CHARACTER FORMAT 'x(25)':U NO-UNDO.
    
    DEFINE VARIABLE hBosc030 AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBosc079 AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBosc092 AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBosc096 AS HANDLE NO-UNDO.
    DEFINE VARIABLE hBosc135 AS HANDLE NO-UNDO.
    
    
    
    /* **********************  Internal Procedures  *********************** */
    
    /* ******************************************************************************************** */
    PROCEDURE CreateTTErro:
    /* ******************************************************************************************** */
    
    
        DEFINE INPUT PARAMETER pCdErro       AS INTEGER    NO-UNDO.
        DEFINE INPUT PARAMETER pDescription  AS CHARACTER  NO-UNDO.
    
         ASSIGN i-cont = i-cont + 1.
    
            CREATE tt-erro.
            ASSIGN tt-erro.cd-erro  = pCdErro
                   tt-erro.mensagem = pDescription 
                   tt-erro.i-sequen = i-cont.
    
    
    END PROCEDURE.
    
    
    
    /* ******************************************************************************************** */
    PROCEDURE LoginUser :
    /* ******************************************************************************************** */
    
        DEFINE INPUT PARAMETER pUser     AS CHARACTER NO-UNDO.
        DEFINE INPUT PARAMETER pPassword AS CHARACTER NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
    
        IF v_cod_usuar_corren = ''  THEN DO:
           FOR each tt-erros:
               DELETE tt-erros.
           END.
           
           login:
              do on error  undo login, leave login
              on quit   undo login, leave login
              on stop   undo login, leave login
              on endkey undo login, leave login:
              
              run btb/btapi910za.p (INPUT pUser, 
                                    INPUT pPassword, 
                                    output table tt-erros).        
           end.
           
           IF RETURN-VALUE <> "OK":U THEN DO:
              FOR EACH tt-erros NO-LOCK:
                  RUN CreateTTErro (INPUT tt-erros.cod-erro, INPUT tt-erros.desc-erro).
              END.
              RETURN "NOK":U.
           END.
    
           ASSIGN vLogControlaLogin = YES. 
    
           RETURN "OK".
        END.
        RETURN "OK".
    
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE ValidateUser:
    /* ******************************************************************************************** */
        DEFINE INPUT  PARAMETER pUser           AS CHARACTER NO-UNDO.
        DEFINE INPUT  PARAMETER pWmsFunction    AS INTEGER   NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
        DEFINE VARIABLE pUtilizaColetor AS LOGICAL   NO-UNDO. 
        DEFINE VARIABLE pAprovaFatura   AS LOGICAL   NO-UNDO. 
    
        
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
        IF NOT VALID-HANDLE(HBosc135)  THEN DO:
           RUN scbo/bosc135.p PERSISTENT SET hBosc135.
           Run openQueryStatic In HBosc135 (Input "Main":U) No-error.
        END.
        IF NOT VALID-HANDLE(HBosc079)  THEN DO:
           RUN scbo/bosc079.p PERSISTENT SET hBosc079.
           Run openQueryStatic In HBosc079 (Input "Main":U) No-error.
        END.
        RUN validaUsuarioTarefa IN HBosc135 (INPUT pUser, INPUT pWmsFunction).
        If Return-value <> 'OK':U Then Do:
            IF vLogControlaLogin = YES THEN                                                                
               ASSIGN v_cod_usuar_corren  = ''                                                             
                      v2_cod_usuar_corren = ''.                                                            
            RUN createTTErro (INPUT 100, INPUT "Usu†rio sem permiss∆o para executar Tarefa (WMS)").
            RUN destroy.
            RETURN "NOK":U.
        END.
    
        RUN validaUsuario IN HBosc079 (INPUT pUser, OUTPUT pUtilizaColetor, OUTPUT pAprovaFatura).
    
        If Return-value <> 'OK':U Then Do:
           IF vLogControlaLogin = YES THEN
              ASSIGN v_cod_usuar_corren  = ''
                     v2_cod_usuar_corren = ''.
           Run getrowErrors In HBosc079 (output Table RowErrors).
           For Each RowErrors:
               ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
               RUN createTTErro (INPUT ErrorNumber, INPUT ErrorDescription).
           END.
           RUN destroy.
           RETURN "NOK":U.
        End.
    
        IF  pUtilizaColetor = NO THEN DO:
            IF vLogControlaLogin = YES THEN
               ASSIGN v_cod_usuar_corren  = ''
                      v2_cod_usuar_corren = ''.
            RUN createTTErro (INPUT 101, INPUT "Usu†rio sem permiss∆o para utilizar Coletor (WMS)").
            RUN destroy.
            Return "NOK":U.
        END.
        RUN destroy.
        RETURN "OK":U.
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE ValidateEquipament:
    /* ******************************************************************************************** */
    
        DEFINE INPUT  PARAMETER pHandheld                AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pTransportEquipament     AS CHARACTER  NO-UNDO.
        DEFINE OUTPUT PARAMETER pTransportEquipamentType AS INTEGER    NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
    
    
        IF NOT VALID-HANDLE(HBosc092)  THEN DO:
           RUN scbo/bosc092.p PERSISTENT SET hBosc092.
           Run openQueryStatic In HBosc092 (Input "Main":U) No-error.
        END.
    
        /* valida se equipamento Ç do tipo coletor */
        RUN validaEquipColetor In HBosc092 (Input  pHandheld,
                                            Output pTransportEquipamentType,
                                            Output vLogAtivo,
                                            Output vLogProcesso).
    
        If  Return-value <> 'OK' Then Do:
            RUN CreateTTErro (INPUT 102, INPUT "Coletor Inv†lido (WMS)").
            RUN destroy.
            Return "NOK":U.
        End.
    
        If   vLogAtivo = No Then Do:
            Assign vLogErro = Yes.
            RUN CreateTTErro (INPUT 103, INPUT "Coletor Inv†lido (WMS)").
        End.
    
        Run validaEquipTransportador In HBosc092  (Input  pTransportEquipament,
                                                   Output pTransportEquipamentType,
                                                   Output vLogAtivo,
                                                   Output vLogProcesso).
        If  Return-value <> 'OK':U Then Do:
            RUN CreateTTErro (INPUT 104, INPUT "Equipamento Inv†lido (WMS)").
            RUN destroy.
            RETURN "NOK":U.
        End.
    
        If  vLogAtivo = No Then Do:
            RUN CreateTTErro (INPUT 105, INPUT "Equipamento Inativo (WMS)").
            RUN destroy.
            RETURN "NOK":U.
        End.
        RUN destroy.
        RETURN "OK":U.
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE GetAddressDescription:
    /* ******************************************************************************************** */
    
        DEFINE INPUT  PARAMETER pCodBox      AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pCod-estabel AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pLocal       AS CHARACTER  NO-UNDO.
        DEFINE OUTPUT PARAMETER pDescription AS CHARACTER  NO-UNDO.
    
    
    
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
        IF NOT VALID-HANDLE (HBosc030) THEN DO:
            RUN scbo/bosc030.p PERSISTENT SET hBosc030.
            Run openQueryStatic In HBosc030 (Input "Main":U) No-error.
        END.
    
        RUN SetConstraintBoxes IN HBosc030 (INPUT pCod-Estabel, 
                                            INPUT pLocal, 
                                            INPUT pCodBox,
                                            INPUT pCodBox).
    
        RUN OpenQueryStatic IN Hbosc030 (INPUT "Boxes":U).
    
        RUN GetRecord IN HBosc030 (OUTPUT TABLE ttwm-box).
    
        IF RETURN-VALUE <> "OK" THEN DO:
            RUN CreatTTErro (INPUT 20, INPUT "Endereáo N∆o Localizado").
            RUN destroy.
            RETURN "NOK".
    
        END.
        FIND FIRST ttwm-box NO-ERROR.
        
        FIND FIRST wm-box WHERE Rowid(wm-box) = ttwm-box.r-Rowid NO-LOCK NO-ERROR.
        IF AVAIL wm-box THEN DO:
            
            ASSIGN pDescription = string(wm-box.cod-bloco) + "/" + string(wm-box.cod-rua) + "/" + 
                                  STRING(wm-box.cod-nivel) + "/" + string(wm-box.cod-coluna)  + "/" .
            ASSIGN pDescription = pDescription + IF wm-box.ind-posicao-box = 1 THEN "E" ELSE "D". 
        END.
        ELSE
            RUN CreateTTErro (INPUT 20, INPUT "Endereáo N∆o Localizado").
    
    
    
        RUN destroy.
        RETURN "OK".
    
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE StartTask:
    /* ******************************************************************************************** */
    
        DEFINE INPUT  PARAMETER pUser                AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pHandheld            AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pTransportEquipament AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pWmsFunction         AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pIdDocto             AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pIdMovto             AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pNumSeqItem          AS INTEGER    NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
        DEFINE VARIABLE lError AS LOGICAL INITIAL NO   NO-UNDO.
    
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
        IF NOT VALID-HANDLE (HBosc096) THEN DO:
            RUN scbo/bosc096.p PERSISTENT SET hBosc096.
            Run openQueryStatic In HBosc096 (Input "Main":U) No-error.
        END.
    
        RUN emptyrowerrors IN hbosc096.
        EMPTY TEMP-TABLE rowerrors. 
        RUN inicializaTarefaMovtoOk IN HBosc096 (INPUT pIdDocto,       
                                                 INPUT pWmsFunction,     
                                                 INPUT pUser,    
                                                 INPUT pTransportEquipament,
                                                 INPUT pHandheld,    
                                                 INPUT pIdMovto,       
                                                 INPUT pNumSeqItem).    
        
        IF RETURN-VALUE <> "OK":U THEN DO:
           RUN getrowerrors IN hbosc096 (OUTPUT TABLE rowerrors).
        
           FOR EACH rowerrors:
               RUN CreateTTErro (INPUT rowerrors.ErrorNumber, INPUT rowerrors.errorDescription).
               ASSIGN lError = YES.
           END.
           RUN destroy.
           RETURN "NOK".
        END.
        
        RUN destroy.
    
        RETURN "OK".
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE StopTask:
    /* ******************************************************************************************** */
    
        DEFINE INPUT  PARAMETER pTransportEquipament AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pUser                AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pHandheld            AS CHARACTER  NO-UNDO.
        DEFINE INPUT  PARAMETER pWmsFunction         AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pIdDocto             AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pIdMovto             AS INTEGER    NO-UNDO.
        DEFINE INPUT  PARAMETER pNumSeqItem          AS INTEGER    NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erros.
    
        FOR EACH tt-erros.
            DELETE tt-erros.
        END.
    
        RUN inicializaTarefaNOk IN HBosc096 (INPUT pIdDocto,       
                                             INPUT pWmsFunction,     
                                             INPUT pUser,    
                                             INPUT pHandheld,
                                             INPUT pTransportEquipament,    
                                             INPUT pIdMovto,       
                                             INPUT pNumSeqItem).    
        IF RETURN-VALUE <> "OK" THEN DO:
            RUN CreateTTErro (INPUT 10, INPUT "Movto Expirou.(WMS)").
            RUN destroy.
            RETURN "NOK".
        END.
        RUN destroy.
        RETURN "OK".
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE Destroy:
    /* ******************************************************************************************** */
    
        /* Elimina as handles da memoria */
    
        IF VALID-HANDLE (hBosc030) THEN
            DELETE OBJECT hBosc030.
    
        IF VALID-HANDLE (hBosc079) THEN
            DELETE OBJECT hBosc079.
    
        IF VALID-HANDLE (hBosc092) THEN
            DELETE OBJECT hBosc092.
    
        IF VALID-HANDLE (hBosc096) THEN
            DELETE OBJECT hBosc096.
    
        IF VALID-HANDLE (hBosc135) THEN
            DELETE OBJECT hBosc135.
    
    
    END PROCEDURE.
    
    /* ******************************************************************************************** */
    PROCEDURE retornaDescLayoutEtiq:
    /* ******************************************************************************************** */
        DEFINE INPUT  PARAMETER tipo-etiqueta LIKE tipo-etiqueta.tipo-etiq  NO-UNDO.
        DEFINE OUTPUT PARAMETER descricao     LIKE tipo-etiqueta.titulo     NO-UNDO.
        DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
    
        FOR EACH tt-erro:
            DELETE tt-erro.
        END.
    
        FIND FIRST tipo-etiqueta 
             WHERE tipo-etiqueta.tipo-etiq = tipo-etiqueta 
             NO-LOCK NO-ERROR.
        IF AVAIL tipo-etiqueta THEN DO:
            ASSIGN descricao = tipo-etiqueta.titulo.
            RETURN "OK":U.    
        END.
        ELSE DO:
            RUN CreateTTErro (INPUT 30, INPUT "Etiqueta Inv†lida").
            RETURN "NOK":U.
    
        END.
    
    
    END PROCEDURE.
    
    
    PROCEDURE piValidaEtiqueta:
        DEFINE INPUT PARAMETER  pCodItem    LIKE wm-docto-itens.cod-item        NO-UNDO.
        DEFINE INPUT PARAMETER  pIdDocto    LIKE wm-docto-itens.id-docto        NO-UNDO.
        DEFINE INPUT PARAMETER  pNumSeqItem LIKE wm-docto-itens.num-seq-item    NO-UNDO.
        DEFINE OUTPUT PARAMETER pTgAchou    AS LOGICAL                          NO-UNDO.
    
        FIND FIRST bc-etiqueta
             WHERE bc-etiqueta.it-codigo        = pCodItem
               AND bc-etiqueta.id-docto         = pIdDocto
               AND bc-etiqueta.sequencia-docto  = pNumSeqItem
            NO-LOCK NO-ERROR. 
    
        ASSIGN pTgAchou = AVAIL bc-etiqueta.
    
    END PROCEDURE.
    
    PROCEDURE piValidaUsuario:
        DEFINE INPUT  PARAMETER  pCodUsuario    AS CHARACTER FORMAT 'x(25)':U NO-UNDO.
        DEFINE OUTPUT PARAMETER  pCodUsuarioVal AS CHARACTER FORMAT 'x(25)':U NO-UNDO.

      /* prÇ-requisito para rodar com o login di AD */
      ASSIGN c-cod-usuario = pCodUsuario.
          
      /* Verifica se foi informado o dominio */
      IF INDEX(pCodUsuario, "/") > 0 THEN
         ASSIGN c-cod-usuario = TRIM(ENTRY(1, ENTRY(2,pCodUsuario,'/'),':':U))
                c-cod-dominio = TRIM(ENTRY(1, ENTRY(1,pCodUsuario,'/'),':':U)).
                    
      FIND FIRST usuar_mestre_ext
           WHERE usuar_mestre_ext.cod_domin_so = c-cod-dominio
             AND usuar_mestre_ext.cod_usuar_so = c-cod-usuario NO-LOCK NO-ERROR.
      IF AVAIL usuar_mestre_ext THEN
         ASSIGN c-cod-usuario = TRIM(usuar_mestre_ext.cod_usuario).

      ASSIGN pCodUsuarioVal = c-cod-usuario.
      
    END PROCEDURE.
    

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
