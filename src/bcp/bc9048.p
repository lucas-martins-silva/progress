/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9048 MBC}
&ENDIF


{include/i-prgvrs.i BC9048 2.00.00.024 } /*** "010024" 31/10/2025 08:48:40 ***/
/********************************************************************************************
**   Programa..: bc9112.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.001 - mar/2003 - Karen de Freitas Machado                         **
**                                                                                         **
**   Objetivo..: Template DB Interface Menu para transacoes                                **
**                                                                                         **
**   Includes..: bc9105.i, bc9102.i                                                        **
**                                                                                         **
********************************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
***************************************************************************************************/

DEFINE NEW GLOBAL SHARED VAR lMenu          AS LOGICAL                               NO-UNDO.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9048
/************************************************************/

/* Definicao Temp-Table tt-erro ---                         */
{bcp/bc9102.i}
{bcp/bc9048.i1} /* definicao variaveis globais coletor e equipamento */
{utp/utapi009.i} /* login */
/************************************************************/

/* Definicao de variaveis do menu ---                       */
{bcp/bc9112.i0} /* Login */
DEFINE VARIABLE c-opcao  AS CHARACTER FORMAT 'x(01)'              NO-UNDO.
DEFINE VARIABLE vDesErro AS CHARACTER VIEW-AS EDITOR SIZE 5 BY 2  NO-UNDO.
DEFINE VARIABLE vLogErro AS LOGICAL INIT NO                       NO-UNDO.
DEFINE VARIABLE vNumErro AS INTEGER FORMAT '>>>>>>9'              NO-UNDO.

DEFINE VARIABLE wgWindow   AS HANDLE                                NO-UNDO.
DEFINE VARIABLE wgbcapiwms AS HANDLE                                NO-UNDO.
DEFINE VARIABLE hPCECBC    AS HANDLE                                NO-UNDO.

DEFINE VARIABLE l-controle AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-logado   AS LOGICAL INITIAL NO NO-UNDO.

DEFINE VARIABLE vcod-usuario     AS CHARACTER FORMAT 'x(25)':U NO-UNDO.
DEFINE VARIABLE vcod-senha       AS CHARACTER FORMAT 'x(18)':U NO-UNDO.
DEFINE VARIABLE vcod-coletor     AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE vcod-equipamento AS CHARACTER FORMAT 'x(14)':U NO-UNDO.
DEFINE VARIABLE cPCECReturn      AS CHARACTER                  NO-UNDO.

DEFINE VARIABLE vCodTipoEquip           AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE vLogProcesso            AS LOGICAL              INIT NO  NO-UNDO.
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
DEFINE FRAME Frame01
    'Menu Transaá∆o'        AT ROW 01 COL 01
    '-------------------'   AT ROW 02 COL 01
    'Usr:'                  AT ROW 03 COL 01
    vcod-usuario            AT ROW 03 COL 05 NO-LABEL FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88
    'Sen:'                  AT ROW 04 COL 01
    vcod-senha              AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88
    'Col'                   AT ROW 05 COL 01
    vcod-coletor            AT ROW 05 COL 05 NO-LABEL
    'Equ:'                  AT ROW 06 COL 01
    vcod-equipamento        AT ROW 06 COL 05 NO-LABEL
        WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.
/************************************************************/

DEFINE VARIABLE wgbosc092 AS HANDLE      NO-UNDO.
DEFINE VARIABLE wgbocl046 AS HANDLE      NO-UNDO.


ASSIGN v_cod-coletor_corren     = ''
       v_cod-equipamento_corren = ''.

DEFINE TEMP-TABLE ttTarefas NO-UNDO
    FIELD cod-tarefa AS INTEGER FORMAT '99'
    FIELD nom-tarefa AS CHARACTER FORMAT 'x(20)'
    FIELD prog-leitura AS CHARACTER FORMAT 'x(256)' 
    FIELD vli-priorid  AS INTEGER
    INDEX id IS PRIMARY vli-priorid nom-tarefa.

DEFINE QUERY qryTarefas FOR ttTarefas.

DEFINE BROWSE brwTarefas QUERY qryTarefas NO-LOCK
    DISPLAY ttTarefas.nom-tarefa
    WITH NO-BOX NO-LABELS SIZE 20 BY 8 NO-SCROLLBAR-VERTICAL.

/* Definicao da Frame02 ---                                 */
DEFINE FRAME Frame02
    brwTarefas          AT ROW 01 COL 01
    WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.

/* Definicao da _Error ---                                  */
DEFINE FRAME _Error
    'Erro:'         AT ROW 1 COL 1 
    vNumErro        AT ROW 1 COL 6 NO-LABEL
    vDesErro        AT ROW 2 COL 1 NO-LABEL
        WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.

ASSIGN vDesErro:Width  = FRAME _Error:Width
       vDesErro:Height = FRAME _Error:Height - 1.
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/***********************************   Codigo Principal   ****************************************/
ASSIGN SESSION:DATA-ENTRY-RETURN = YES.
IF SESSION:WINDOW-SYSTEM <> 'TTY' THEN DO:
    CREATE WINDOW wgWindow ASSIGN
          STATUS-AREA  = NO
          MESSAGE-AREA = NO
          WIDTH        = FRAME Frame01:Width
          HEIGHT       = FRAME Frame01:Height
          TITLE        = 'Menu'.
    ASSIGN Current-window = wgWindow.
END.

ASSIGN lMenu = YES.

ON 'Enter':U OF brwTarefas IN FRAME Frame02
DO:
    ASSIGN v_cod-coletor_corren     = vcod-coletor
           v_cod-equipamento_corren = vcod-equipamento.
    HIDE ALL NO-PAUSE.
    RUN VALUE(ttTarefas.prog-leitura).
    HIDE ALL NO-PAUSE.
    VIEW FRAME Frame02.
END.

ON 'Esc':U OF brwTarefas IN FRAME Frame02
DO:
    ASSIGN l-controle = NO               
           vcod-senha   = '****************'
           vcod-senha:SCREEN-VALUE IN FRAME Frame01     = '****************'.
END.

REPEAT  ON ERROR UNDO, RETRY
        ON ENDKEY UNDO, LEAVE:
    
    IF SESSION:WINDOW-SYSTEM <> 'TTY' THEN
        ASSIGN wgWindow:TITLE = "Menu".

    VIEW FRAME Frame01.

    IF v_cod_usuar_corren <> '' THEN DO:
        ASSIGN l-logado = YES
               vcod-usuario = v_cod_usuar_corren
               vcod-usuario:SCREEN-VALUE IN FRAME Frame01   = v_cod_usuar_corren
               vcod-senha   = '****************'
               vcod-senha:SCREEN-VALUE IN FRAME Frame01     = '****************'.
        UPDATE vcod-coletor vcod-equipamento WITH FRAME Frame01.
    END.
    ELSE DO:
        ASSIGN vcod-senha:blank IN FRAME frame01 = YES.
        UPDATE vcod-usuario vcod-senha vcod-coletor vcod-equipamento WITH FRAME Frame01.
        ASSIGN vcod-senha:SCREEN-VALUE IN FRAME Frame01 = '****************'.
    END.

    IF vcod-usuario = '' THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "101" "Usu†rio Inv†lido (DC)"}
        UNDO, RETRY.
    END.

    IF NOT l-logado THEN DO:
    
        IF NOT VALID-HANDLE(hPCECBC) THEN
            RUN fwk/utils/ProgressClientExecutionControl.p PERSISTENT SET hPCECBC.
    
        ASSIGN v_cod_usuar_corren = vcod-usuario.
    
        RUN piExecutionControl IN hPCECBC (OUTPUT cPCECReturn).
        IF cPCECReturn <> "OK" THEN DO:
            {bcp/bc9105.i "56515" "Limite m†ximo de sess‰es conectadas para o usu†rio."}
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''
                   cPCECReturn        = ''.
            UNDO, RETRY.
        END.
        
        IF VALID-HANDLE(hPCECBC) THEN
            DELETE PROCEDURE hPCECBC NO-ERROR.
            
        ASSIGN v_cod_usuar_corren = ''.
            
        RUN btb/btapi910za.p (INPUT vcod-usuario,
                              INPUT vcod-senha,
                              OUTPUT TABLE tt-erros) NO-ERROR.
    

        IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4755) THEN DO:
            {bcp/bc9105.i "4755" "Senha Expirou. Favor contactar o Administrador do Sistema!(DC)"}
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            UNDO, RETRY.
        END.

        IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
            {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado!(DC)"}
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            UNDO, RETRY.
        END.
        ELSE DO:
            IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
                {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta!(DC)"} 
                ASSIGN vLogErro           = YES
                       v_cod_usuar_corren = ''.
                UNDO, RETRY.
            END.
        END.
        IF NOT VALID-HANDLE(wgbcapiwms) THEN
            RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.
       
        RUN piValidaUsuario IN wgbcapiwms (INPUT vcod-usuario,
                                           OUTPUT vcod-usuario).
                                           
        IF VALID-HANDLE(wgbcapiwms) THEN
            DELETE PROCEDURE wgbcapiwms NO-ERROR.                                           
    END.   
    
    IF vcod-coletor = '' THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "102" "Coletor Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF vcod-equipamento = '' THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "103" "Equipamento Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF NOT VALID-HANDLE(wgbosc092) THEN DO:
       RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
       RUN EmptyRowErrors IN wgbosc092.
    END.

    RUN validaEquipColetor IN wgbosc092  (INPUT  vcod-coletor,
                                          OUTPUT vCodTipoEquip,
                                          OUTPUT vLogAtivo,
                                          OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK':U THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "103" "Coletor Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF NOT vLogAtivo THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
        UNDO, RETRY.
    END.

    RUN validaEquipTransportador IN wgbosc092  (INPUT  vcod-equipamento,
                                                OUTPUT vCodTipoEquip,
                                                OUTPUT vLogAtivo,
                                                OUTPUT vLogProcesso).
    IF RETURN-VALUE <> 'OK':U THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "104" "Equipamento Inv†lido (WMS)"}
        UNDO, RETRY.
    END.

    IF VALID-HANDLE(wgbosc092) THEN RUN destroy IN wgbosc092.

    IF vLogAtivo = NO THEN DO:
        ASSIGN vLogErro = YES.
        {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
        UNDO, RETRY.
    END.

    ASSIGN l-controle = YES.
    REPEAT  ON ERROR UNDO, RETRY
            ON ENDKEY UNDO, LEAVE:
        RUN MontaMenu.
        IF l-controle = NO THEN LEAVE.
    END.
END.

ASSIGN SESSION:DATA-ENTRY-RETURN = NO.

IF VALID-HANDLE(wgWindow) THEN DO:
    ASSIGN wgWindow:VISIBLE = NO.
    DELETE  OBJECT wgWindow.
END.

RETURN.
/**************************************************************************************************/

/*********************************** Procedures Internas ******************************************/
PROCEDURE MontaMenu:
    ASSIGN vLogErro = NO.

    EMPTY TEMP-TABLE ttTarefas.

    IF NOT VALID-HANDLE(wgbocl046) THEN DO:
       RUN clbo/bocl046.p PERSISTENT SET wgbocl046 NO-ERROR.
    END.
	
    RUN retornaTarefa IN wgbocl046 (INPUT vcod-usuario,
                                    OUTPUT TABLE ttTarefas).
                                    
    IF VALID-HANDLE(wgbocl046) THEN
        DELETE PROCEDURE wgbocl046 NO-ERROR.

    IF NOT CAN-FIND(FIRST ttTarefas) THEN DO:
        {bcp/bc9105.i "17006" "N∆o existem transaá‰es associadas ao usu†rio (WMS)"}
        ASSIGN l-controle = NO.
        RETURN.
    END.

    HIDE FRAME Frame01.
    
    IF SESSION:WINDOW-SYSTEM <> 'TTY' THEN
    ASSIGN wgWindow:TITLE = "Menu".

    OPEN QUERY qryTarefas FOR EACH ttTarefas.
	
    VIEW FRAME Frame02.
    UPDATE brwTarefas WITH FRAME Frame02.

    IF  FRAME Frame01:Visible = YES THEN
        HIDE FRAME Frame01.

    IF  FRAME Frame02:Visible = YES THEN
        HIDE FRAME Frame02.

    ASSIGN lMenu = NO.


END PROCEDURE.

FINALLY:   
   
   ASSIGN lMenu = NO
          v_cod-coletor_corren     = ""  
          v_cod-equipamento_corren = "".
    
   IF THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
 
   RETURN 'OK':U.
END FINALLY.
