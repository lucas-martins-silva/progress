
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AFAPI003 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i afapi003 MAF}
&ENDIF

/********************************************************************************************
**
**       Programa.: AFAPI003.P   
**
**       Data.....: Fevereiro de 2013
**
**       Objetivo.: Grava‡Æo de Altera‡äes no Hist¢rico de Altera‡äes
**
**       Cria‡Æo..: Rodrigo 
**
*******************************************************************************************/
{afp/afapi003.i}
{utp/ut-glob.i}
DEFINE VARIABLE h-boaf024 AS HANDLE         NO-UNDO.

PROCEDURE pi-salva-valor-antigo:
/* 
    Procedure para fazer a leitura do registro antes de ser alterado
    Recebe como parƒmetro o nome da tabela e o RowId

*/
    DEFINE INPUT PARAMETER pTabela AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pRowid AS ROWID NO-UNDO.
/*
    Para cada tabela ‚ feito um find pelo RowId e feito um buffer-copy para a temp-table.
*/
    CASE pTabela:
        WHEN 'param-af':U THEN DO:
            FIND FIRST param-af NO-LOCK
                WHERE ROWID(param-af) = pRowid NO-ERROR.
            IF AVAIL param-af THEN DO:
                EMPTY TEMP-TABLE tt-param-af-old.
                CREATE tt-param-af-old.
                BUFFER-COPY param-af TO tt-param-af-old.
            END.
        END.
        WHEN 'af-versao-avaliacao':U THEN DO:
            FIND FIRST af-versao-avaliacao NO-LOCK
                WHERE ROWID(af-versao-avaliacao) = pRowid NO-ERROR.
            IF AVAIL af-versao-avaliacao THEN DO:
                EMPTY TEMP-TABLE tt-af-versao-avaliacao-old.
                CREATE tt-af-versao-avaliacao-old.
                BUFFER-COPY af-versao-avaliacao TO tt-af-versao-avaliacao-old.                
            END.
        END.
        WHEN 'af-periodo-aval':U THEN DO:
            FIND FIRST af-periodo-aval NO-LOCK
                WHERE ROWID(af-periodo-aval) = pRowid NO-ERROR.
            IF AVAIL af-periodo-aval THEN DO:
                EMPTY TEMP-TABLE tt-af-periodo-aval-old.
                CREATE tt-af-periodo-aval-old.
                BUFFER-COPY af-periodo-aval TO tt-af-periodo-aval-old.
            END.
        END.
    END CASE.
END.

PROCEDURE pi-salva-alteracao:
/*
    Essa procedure tem por objetivo gravar os dados ap¢s alterados para as tabelas informadas:
    pTabela -> Tabela que est  sendo alterada
    pRowid  -> RowId do Dado que est  sendo passado
    pPrograma -> Programa que est  chamando essa API
*/
    DEFINE INPUT PARAMETER pTabela      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pRowid       AS ROWID NO-UNDO.
    DEFINE INPUT PARAMETER pPrograma    AS CHARACTER NO-UNDO.

    DEFINE VARIABLE cCampos AS CHARACTER   NO-UNDO.

    CASE pTabela:
        WHEN 'param-af':U THEN DO:            
            FIND FIRST param-af NO-LOCK
                WHERE ROWID(param-af) = pRowid NO-ERROR.

            IF AVAIL param-af THEN DO:
                EMPTY TEMP-TABLE tt-param-af-new.                

                CREATE tt-param-af-new.

                BUFFER-COPY param-af TO tt-param-af-new.
                /*Compara os valores da Temp-Table com os dados antigos com os dados novos e recebe como retorno uma
                    string com campos que foram alterados*/                
                BUFFER-COMPARE tt-param-af-old TO tt-param-af-new SAVE RESULT IN cCampos.
                /*Chama a procedure que vai tratar as diferen‡as dos campos alterados.*/
                RUN pi-processa-buffer IN THIS-PROCEDURE (INPUT BUFFER tt-param-af-new:HANDLE,
                                                          INPUT BUFFER tt-param-af-old:HANDLE,
                                                          INPUT cCampos,
                                                          INPUT pTabela,
                                                          INPUT STRING(param-af.seq-param-af),
                                                          INPUT pPrograma).
            END.
        END.
        WHEN 'af-versao-avaliacao':U THEN DO:            
            FIND FIRST af-versao-avaliacao NO-LOCK
                WHERE ROWID(af-versao-avaliacao) = pRowid NO-ERROR.
            IF AVAIL af-versao-avaliacao THEN DO:                
                EMPTY TEMP-TABLE tt-af-versao-avaliacao-new.
                CREATE tt-af-versao-avaliacao-new.
                BUFFER-COPY af-versao-avaliacao TO tt-af-versao-avaliacao-new.
                BUFFER-COMPARE tt-af-versao-avaliacao-old TO tt-af-versao-avaliacao-new SAVE RESULT IN cCampos.
                
                RUN pi-processa-buffer IN THIS-PROCEDURE (INPUT BUFFER tt-af-versao-avaliacao-new:HANDLE,
                                                          INPUT BUFFER tt-af-versao-avaliacao-old:HANDLE,
                                                          INPUT cCampos,
                                                          INPUT pTabela,
                                                          INPUT STRING(af-versao-avaliacao.nr-versao),
                                                          INPUT pPrograma).

            END.
        END.
        WHEN 'af-periodo-aval':U THEN DO:
            FIND FIRST af-periodo-aval NO-LOCK
                WHERE ROWID(af-periodo-aval) = pRowid NO-ERROR.
            IF AVAIL af-periodo-aval THEN DO:
                EMPTY TEMP-TABLE tt-af-periodo-aval-new.
                CREATE tt-af-periodo-aval-new.
                BUFFER-COPY af-periodo-aval TO tt-af-periodo-aval-new.
                BUFFER-COMPARE tt-af-periodo-aval-old TO tt-af-periodo-aval-new SAVE RESULT IN cCampos.

                RUN pi-processa-buffer IN THIS-PROCEDURE (INPUT BUFFER tt-af-periodo-aval-new:HANDLE,
                                                          INPUT BUFFER tt-af-periodo-aval-old:HANDLE,
                                                          INPUT cCampos,
                                                          INPUT pTabela,
                                                          INPUT STRING(af-periodo-aval.ano-avaliacao),
                                                          INPUT pPrograma).
            END.
        END.
    END CASE.  
END.

PROCEDURE pi-processa-buffer:
    /*  Procedure que tratar  os valores alterados e chamar  a procedure para gravar os dados.
        phNewBuffer     -> Buffer da Temp-Table alterada
        phOldBuffer     -> Buffer da Temp-Table com os dados originais
        pChanges        -> Vari vel com os campos que foram alterados
        pTabela         -> Tabela que est  sendo alterado
        pchave          -> Chave da Tabela
        pPrograma       -> Programa que est  chamando a procedure
    
    */    

    DEFINE INPUT  PARAMETER phNewBuffer AS HANDLE       NO-UNDO.
    DEFINE INPUT  PARAMETER phOldBuffer AS HANDLE       NO-UNDO.
    DEFINE INPUT  PARAMETER pChanges    AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pTabela     AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pchave      AS CHARACTER    NO-UNDO.
    DEFINE INPUT  PARAMETER pPrograma   AS CHARACTER    NO-UNDO.

    DEFINE VARIABLE obf AS HANDLE               NO-UNDO.
    DEFINE VARIABLE nbf AS HANDLE               NO-UNDO.
    DEFINE VARIABLE f   AS INTEGER              NO-UNDO.
    DEFINE VARIABLE f1  AS INTEGER INIT 0       NO-UNDO.
    DEFINE VARIABLE iExtent AS INTEGER INIT 0   NO-UNDO.
    /*DEFINE VARIABLE h-boaf024 AS HANDLE         NO-UNDO.*/

    /*
        Inicia a BOAF024 para gravar o hist¢rico
    */
    IF NOT VALID-HANDLE(h-boaf024) THEN DO:
       RUN afbo/boaf024.p PERSISTENT SET h-boaf024.
    END.
    RUN openQueryStatic IN h-boaf024 (INPUT "Main":U) NO-ERROR.

    /* 
        Faz um loop para todos os campos alterados
    */
    DO f = 1 TO NUM-ENTRIES(pChanges,","):

        /* 
           Posiciona no registro da da Temp-Table para o campo corrente
        */        

        ASSIGN  nbf = phNewBuffer:BUFFER-FIELD(ENTRY(f,pChanges))
                obf = phOldBuffer:BUFFER-FIELD(ENTRY(f,pChanges))
                iExtent = 0.

        /*
            Procura nas tabelas dos banco pelas defini‡äes da tabela
            e campo corrente.
            Primeiro Busca se a tabela existe e se existir busca pelo nome do campo
            e pega a quantidade de Extent
        */
        &IF "{&ems_dbtype}":U = "progress":U &THEN
            /*Para bancos Progress utilizar o banco emsdca*/
            FIND FIRST emsdca._file NO-LOCK
                WHERE emsdca._file._file-name = pTabela NO-ERROR.
            IF AVAIL emsdca._file THEN DO:
                FIND FIRST  emsdca._field NO-LOCK 
                    WHERE emsdca._field._file-recid = RECID(emsdca._file)
                    AND emsdca._field._field-name = ENTRY(f,pChanges) NO-ERROR.
                IF AVAIL emsdca._field THEN
                    ASSIGN iExtent = emsdca._field._extent.
            END.
        &ELSE 
            /*Para bancos Progress utilizar o banco shemsdca*/
            FIND FIRST shemsdca._file NO-LOCK
                WHERE shemsdca._file._file-name = pTabela NO-ERROR.
            IF AVAIL shemsdca._file THEN DO:
                FIND FIRST  shemsdca._field NO-LOCK 
                    WHERE shemsdca._field._file-recid = RECID(shemsdca._file)
                    AND shemsdca._field._field-name = ENTRY(f,pChanges) NO-ERROR.
                IF AVAIL shemsdca._field THEN
                    ASSIGN iExtent = shemsdca._field._extent.
            END.
        &ENDIF
        
        IF iExtent > 0 THEN
            /*Se tem Extent faz um DO para todas as posi‡äes do Extent
                Em seguida compara o antigo com o novo e verifica se houve altera‡Æo, se existir grava no banco.*/
            DO f1 = 1 TO iExtent:
                IF TRIM(obf:STRING-VALUE(f1)) <>  TRIM(nbf:STRING-VALUE(f1)) THEN              
                    RUN pi-af-historico-alteracao IN THIS-PROCEDURE (INPUT pTabela, 
                                                             INPUT ENTRY(f,pChanges) + '[':U + STRING(f1) + ']':U,
                                                             INPUT pchave,
                                                             INPUT TRIM(obf:STRING-VALUE(f1)),
                                                             INPUT TRIM(nbf:STRING-VALUE(f1)),
                                                             INPUT pPrograma).    
            END.
        ELSE DO:            
            RUN pi-af-historico-alteracao IN THIS-PROCEDURE (INPUT pTabela, 
                                                             INPUT ENTRY(f,pChanges),
                                                             INPUT pchave,
                                                             INPUT TRIM(obf:STRING-VALUE()),
                                                             INPUT TRIM(nbf:STRING-VALUE()),
                                                             INPUT pPrograma).
            END.
    END.

    /*
        Elimina o Handle do BOAF024
    */
    IF VALID-HANDLE(h-boaf024) THEN DO:
        DELETE PROCEDURE h-boaf024.
        ASSIGN h-boaf024 = ?.
    END.
END.

PROCEDURE pi-af-historico-alteracao:
    DEFINE INPUT PARAMETER pTabela      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pcampo       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pchave       AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pvl-anterior AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pvl-novo     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pPrograma    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iseq AS INTEGER     NO-UNDO.                                 

    RUN pi-next-sequence IN h-boaf024 (OUTPUT iseq).

    EMPTY TEMP-TABLE tt-af-historico-alteracao.

    /*
        Grava os dados na Tabela af-historico-alteracao
    */
    CREATE  tt-af-historico-alteracao.
    ASSIGN  tt-af-historico-alteracao.seq           = iseq
            tt-af-historico-alteracao.ep-codigo     =  i-ep-codigo-usuario
            tt-af-historico-alteracao.nome-tabela   =  pTabela
            tt-af-historico-alteracao.campo         =  pcampo
            tt-af-historico-alteracao.chave         =  pchave
            tt-af-historico-alteracao.vl-anterior   =  pvl-anterior
            tt-af-historico-alteracao.vl-novo       =  pvl-novo
            tt-af-historico-alteracao.usuar-alter   =  c-seg-usuario
            tt-af-historico-alteracao.dt-alter      =  TODAY
            tt-af-historico-alteracao.hora-alter    =  STRING(TIME,"HH:MM:SS")
            tt-af-historico-alteracao.prog-alter    =  pPrograma.


        RUN emptyRowErrors IN h-boaf024.
        RUN setRecord IN h-boaf024 (INPUT TABLE tt-af-historico-alteracao). 
	    RUN createRecord IN h-boaf024.

END.

RETURN "OK".
