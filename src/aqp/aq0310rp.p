/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0310RP 2.00.00.015 } /*** "010015" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQ0310RP MAQ}
&ENDIF

/* definiá∆o das temp-tables para recebimento de parÉmetros */
DEFINE TEMP-TABLE tt-param      NO-UNDO 
    FIELD destino               AS INTEGER 
    FIELD arq-destino           AS CHAR FORMAT "x(50)":U
    FIELD usuario               AS CHAR FORMAT "x(12)":U
    FIELD data-exec             AS DATE 
    FIELD hora-exec             AS INTEGER 
    FIELD arq-entrada           AS CHAR FORMAT "x(70)":U.

DEFINE TEMP-TABLE tt-result-carg NO-UNDO 
    FIELD num-carg          like carg-rural.num-carg  
    FIELD cod-carga         like carg-rural.cod-carga 
    FIELD cod-placa         like carg-rural.cod-placa 
    FIELD cod-rota          like carg-rural.cod-rota  
    FIELD situacao          AS   CHAR
    FIELD erro-desc         AS   CHAR.

DEFINE TEMP-TABLE tt-result-produt NO-UNDO 
    FIELD num-carg                like carg-rural.num-carg
    FIELD cdn-produt-rural        AS CHAR FORMAT "x(12)"
    FIELD cod-pto-coleta          like produt-carg.cod-pto-coleta  
    FIELD cdn-repos               AS CHAR FORMAT "x(8)"  
    FIELD dat-trans               AS CHAR FORMAT "X(10)"       
    FIELD qtd-coleta              AS CHAR FORMAT "x(17)"  
    FIELD situacao                AS   CHAR
    FIELD erro-desc               AS   CHAR.

DEFINE TEMP-TABLE tt-produt-carg-automat NO-UNDO
    FIELD cdn-identif       LIKE produt-carg.cdn-identif      
    FIELD cod-estabel       LIKE produt-carg.cod-estabel      
    FIELD num-carg          LIKE produt-carg.num-carg         
    FIELD cdn-produt-rural  LIKE produt-carg.cdn-produt-rural 
    FIELD cod-pto-coleta    LIKE produt-carg.cod-pto-coleta.

define temp-table tt-raw-digita
    field raw-digita     as raw.    

/* recebimento de parÉmetros */
def input parameter raw-param as raw NO-UNDO.
def input parameter table for tt-raw-digita.

create tt-param.
raw-transfer raw-param to tt-param.

/* include padr∆o para vari†veis para o log */
{include/i-rpvar.i}
{utp/ut-glob.i}

/* definiá∆o de vari†veis e streams */
DEF STREAM s-imp.

DEF VAR h-acomp            AS HANDLE                    NO-UNDO.
DEF VAR h-boin00961        AS HANDLE                    NO-UNDO.
DEF VAR h-boin00965        AS HANDLE                    NO-UNDO.
DEF VAR h-aqapi003         AS HANDLE                    NO-UNDO.
DEF VAR h-boin00990        AS HANDLE                    NO-UNDO.
DEF VAR h-boin00966        AS HANDLE                    NO-UNDO.
DEF VAR h-boin00962        AS HANDLE                    NO-UNDO.
DEF VAR h-aqapi005         AS HANDLE                    NO-UNDO.
DEF VAR c-linha            AS CHAR                      NO-UNDO.
DEF VAR c-texto            AS CHAR                      NO-UNDO.
DEF VAR c-sit              AS CHAR                      NO-UNDO.
DEF VAR c-sit-prod         AS CHAR                      NO-UNDO.
DEF VAR i-seq-produtor     AS INT                       NO-UNDO.
DEF VAR i-num-carg         LIKE carg-rural.num-carg     NO-UNDO.
DEF VAR c-destino          AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEF VAR c-parametros       AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEF VAR c-impressao        AS CHARACTER FORMAT "x(10)"  NO-UNDO.
DEF VAR rRowid             AS ROWID                     NO-UNDO.
DEF VAR i-status           AS INTEGER                   NO-UNDO.
DEF VAR i-seq              AS INTEGER                   NO-UNDO.

DEF VAR i-transp             AS INT                  NO-UNDO.
DEF VAR de-data-trans        AS DATE                 NO-UNDO.
DEF VAR i-qti-comptmento     AS INT                  NO-UNDO.
DEF VAR de-val-densidade     AS DEC                  NO-UNDO.
DEF VAR de-val-hodom-inicial AS DEC                  NO-UNDO.
DEF VAR de-val-hodom-final   AS DEC                  NO-UNDO.
DEF VAR de-qtd-peso-brut     AS DEC                  NO-UNDO.

DEF VAR i-repos             AS INT                   NO-UNDO.
DEF VAR de-val-temperat     AS DEC                   NO-UNDO.
DEF VAR i-cdn-compart       AS INT                   NO-UNDO.
DEF VAR de-qtd-coleta       AS DEC                   NO-UNDO.
DEF VAR i-cdn-produt-rural  AS INT                   NO-UNDO.

DEF VAR c-hora-convertida      AS CHAR               NO-UNDO.
DEF VAR c-entry-data-coleta    AS CHAR               NO-UNDO.
DEF VAR i-cdn-motiv-nao-coleta AS INT                NO-UNDO.
DEF VAR i-hora-coleta          AS INT                NO-UNDO.
DEF VAR de-data-coleta         AS DATE               NO-UNDO.
DEF VAR de-qtd-medid-regua     AS DEC                NO-UNDO.

{inbo/boin00961.i tt-carg-rural}
{inbo/boin00965.i tt-produt-carg}

DEF BUFFER bftt-produt-carg FOR tt-produt-carg.

{method/dbotterr.i}  /*--- Include com definiá∆o da temp-table RowErrors ---*/

def temp-table tt-editor no-undo
    field linha      as integer
    field conteudo   AS CHARacter format "x(80)"
    index editor-id is primary unique linha.

DEF VAR l-erro          AS LOGICAL NO-UNDO.
DEF VAR l-erro-prod     AS LOGICAL NO-UNDO.
DEF VAR c-erro          AS CHAR    NO-UNDO.
DEF VAR c-erro-desc     AS CHAR    NO-UNDO.
DEF VAR c-erro-produt   AS CHAR    NO-UNDO.
DEF VAR l-produt-resp   AS LOGICAL NO-UNDO.
DEF VAR l-achou-produt  AS LOGICAL NO-UNDO.
DEF VAR iProdutResposns as INT     NO-UNDO.
DEF VAR cPropriedade    AS CHAR    NO-UNDO.

/* definic∆o de frames */
form
   skip(2)
   c-parametros            no-label AT 22 skip(1)
   tt-param.arq-entrada    colon 53 label "Arquivo de Entrada" SKIP
   c-impressao             AT 22 NO-LABEL skip(1)
   c-destino               COLON 53 LABEL "Destino" " - " tt-param.arq-destino no-label skip
   tt-param.usuario        COLON 53 LABEL "Usu†rio" skip(1)
   with stream-io side-labels no-attr-space no-box width 132 frame f-param.
run utp/ut-trfrrp.p (input frame f-param:handle).

{utp/ut-liter.i PAR∂METROS * r }
assign c-parametros = return-value.
{utp/ut-liter.i IMPRESS«O * r }
assign c-impressao = return-value. 
{utp/ut-liter.i Erros}
assign c-erro = trim(return-value).

form
    tt-result-carg.num-carg       column-label "Nr. Carga"
    tt-result-carg.cod-carga      column-label "Carga"
    tt-result-carg.cod-placa      column-label "Placa"
    tt-result-carg.cod-rota       column-label "Rota"
    tt-result-carg.situacao       column-label "Situaá∆o" 
    tt-result-carg.erro-desc COLUMN-LABEL "Erros" FORMAT "X(69)" skip
    with down stream-io width 132 frame f-log.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-log:HANDLE).

form
    tt-result-produt.cdn-produt-rural column-label "Produtor" AT 8
    tt-result-produt.cod-pto-coleta   column-label "Pto. Coleta"
    tt-result-produt.cdn-repos        COLUMN-LABEL "Repos"
    tt-result-produt.dat-trans        column-label "Data Trans."   
    tt-result-produt.qtd-coleta       column-label "Qtde Coleta"
    tt-result-produt.situacao         column-label "Sit" FORMAT "X(3)" 
    tt-result-produt.erro-desc        COLUMN-LABEL "Erros" FORMAT "X(54)" skip
    with down stream-io width 132 frame f-log-prod.

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
RUN utp/ut-trfrrp.p (INPUT FRAME f-log-prod:HANDLE).


/* include padrao para output de log */
{include/i-rpout.i &STREAM="stream str-rp" &TOFILE=tt-param.arq-destino}

/* include com a definiá∆o da frame de cabeáalho e rodapÇ */
{include/i-rpcab.i &STREAM="str-rp"}

/* bloco principal do programa */
find first param-global no-lock no-error.

assign c-programa     = "AQ0310"
       c-versao       = "2.00"
       c-revisao      = ".00.000"
       c-empresa      = param-global.grupo.

{utp/ut-liter.i "Importaá∆o_de_Mapa_de_Coleta" *}
ASSIGN c-titulo-relat = RETURN-VALUE.
       
{utp/ut-liter.i "Aquisiá‰es_de_Produtos_Rurais" *}
ASSIGN c-sistema = RETURN-VALUE.
       
view stream str-rp frame f-cabec.
view stream str-rp frame f-rodape.

run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Importando... *}

run pi-inicializar in h-acomp (input RETURN-VALUE).

RUN inbo/boin00961.p PERSISTENT SET h-boin00961.

RUN inbo/boin00965.p PERSISTENT SET h-boin00965.
RUN getCreateSequence in h-boin00965 (OUTPUT i-seq-produtor).

RUN inbo/boin00962.p PERSISTENT SET h-boin00962.
RUN openQueryStatic IN h-boin00962 (INPUT "Main":U).

RUN inbo/boin00966.p PERSISTENT SET h-boin00966.
RUN openQueryStatic IN h-boin00966 (INPUT "Main":U).

RUN inbo/boin00990.p PERSISTENT SET h-boin00990.
RUN openQueryStatic IN h-boin00990 (INPUT "Main":U).

RUN aqp/aqapi005.p PERSISTENT SET h-aqapi005.

/* define o arquivo de entrada informado na p†gina de parÉmetros */
input stream s-imp from value(tt-param.arq-entrada).

repeat on stop undo, leave:

    import stream s-imp unformatted c-linha.
    {utp/ut-liter.i Carga: *}
    run pi-acompanhar in h-acomp (input RETURN-VALUE + " " + entry(2,c-linha,";")).
    
    for each RowErrors:
        delete RowErrors.
    end.

    FOR EACH tt-produt-carg-automat:
        DELETE tt-produt-carg-automat.
    END.
    
    assign l-erro = no
           c-sit  = "OK".

    IF entry(1,c-linha,";") <> "1" AND entry(1,c-linha,";") <> "2" THEN DO: 
        {utp/ut-liter.i "C¢digo_de_Registro_Inv†lido"}
        CREATE tt-result-carg.
        ASSIGN tt-result-carg.num-carg  = 0   
               tt-result-carg.cod-carga = entry(2,c-linha,";")  
               tt-result-carg.cod-placa = entry(8,c-linha,";")  
               tt-result-carg.cod-rota  = entry(4,c-linha,";") 
               tt-result-carg.situacao  = "NOK"
               tt-result-carg.erro-desc = RETURN-VALUE.
    END.

    /* Registro 1 - Carga Rural */ 
    IF entry(1,c-linha,";") = "1" THEN DO:
        
        ASSIGN i-num-carg = 0.
        RUN getCreateSequence in h-boin00961 (OUTPUT i-num-carg).
        
        /*Valida conte£do dos campos*/
        ASSIGN i-transp = int(entry(6,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Transportador_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.

        /*Valida conte£do dos campos*/
        ASSIGN de-val-hodom-inicial = DEC(entry(10,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Valor_Hodìmetro_Inicial_aceita_somente_n£meros"}
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF de-val-hodom-inicial < 0 THEN DO:
                {utp/ut-liter.i "Valor_Hodìmetro_Inicial_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.
        END.

        /*Valida conte£do dos campos*/
        ASSIGN de-val-hodom-final = DEC(entry(11,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Valor_Hodìmetro_Final_aceita_somente_n£meros"}
            RUN pi-create-erro (INPUT RETURN-VALUE).

        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF de-val-hodom-final < 0 THEN DO:
                {utp/ut-liter.i "Valor_Hodìmetro_Final_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.                                        
        END.    

        ASSIGN de-qtd-peso-brut = DEC(entry(14,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Peso_Bruto_aceita_somente_n£meros"}
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF de-qtd-peso-brut < 0 THEN DO:
                {utp/ut-liter.i "Peso_Bruto_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.                                        
        END.    

        ASSIGN de-val-densidade = DEC(entry(15,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Densidade_aceita_somente_n£meros"}  
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF de-val-densidade < 0 THEN DO:
                {utp/ut-liter.i "Densidade_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.
        END.

        IF trim(entry(2,c-linha,";")) = "" THEN DO:
            {utp/ut-liter.i "C¢digo_da_Carga_n∆o_informado"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.

        ASSIGN de-data-trans = DATE(entry(16,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 

            IF ERROR-STATUS:GET-NUMBER(1) = 79 THEN DO:
                {utp/ut-liter.i "Ano_inv†lido_para_o_campo_Data_de_Transaá∆o"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.

            IF ERROR-STATUS:GET-NUMBER(1) = 80 THEN DO:
                {utp/ut-liter.i "Màs_inv†lido_para_o_campo_Data_de_Transaá∆o"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.
            
            IF ERROR-STATUS:GET-NUMBER(1) = 81 THEN DO:
                {utp/ut-liter.i "Dia_inv†lido_para_o_campo_Data_de_Transaá∆o"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.

            IF ERROR-STATUS:GET-NUMBER(1) = 85 THEN DO:
                {utp/ut-liter.i "Data_de_Transaá∆o_inv†lida"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.
            
        END.

        ASSIGN i-qti-comptmento = int(entry(17,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Qtd_Compartimento_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF i-qti-comptmento < 0 THEN DO:
                {utp/ut-liter.i "Qtd_Compartimento_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
            END.                                        
        END.


        ASSIGN c-erro-produt = "".
        FOR EACH RowErrors:
            ASSIGN c-erro-produt = c-erro-produt + RowErrors.ErrorDescription + CHR(13).
            DELETE RowErrors.
        END.

        IF c-erro-produt <> "" THEN DO:
            CREATE tt-result-carg.
            ASSIGN tt-result-carg.num-carg  = i-num-carg   
                   tt-result-carg.cod-carga = entry(2,c-linha,";")  
                   tt-result-carg.cod-placa = entry(8,c-linha,";")  
                   tt-result-carg.cod-rota  = entry(4,c-linha,";") 
                   tt-result-carg.situacao  = "NOK"
                   tt-result-carg.erro-desc = c-erro-produt.
            NEXT.
        END.

        CREATE tt-carg-rural.
        ASSIGN tt-carg-rural.num-carg          = i-num-carg
               tt-carg-rural.cod-carga         = entry(2,c-linha,";")
               tt-carg-rural.cod-estabel       = entry(3,c-linha,";")
               tt-carg-rural.cod-rota          = entry(4,c-linha,";")
               tt-carg-rural.nom-motorista     = entry(5,c-linha,";")
               tt-carg-rural.cod-transp        = int(entry(6,c-linha,";"))
               tt-carg-rural.cod-inter-veic    = entry(7,c-linha,";")
               tt-carg-rural.cod-placa         = entry(8,c-linha,";")
               tt-carg-rural.cod-uf            = entry(9,c-linha,";")
               tt-carg-rural.val-hodom-inicial = dec(entry(10,c-linha,";")) / 1000 
               tt-carg-rural.val-hodom-final   = dec(entry(11,c-linha,";")) / 1000
               tt-carg-rural.it-codigo         = entry(12,c-linha,";")
               tt-carg-rural.cod-refer         = entry(13,c-linha,";")
               tt-carg-rural.qtd-peso-brut     = dec(entry(14,c-linha,";")) / 10000
               tt-carg-rural.val-densidade     = dec(entry(15,c-linha,";")) / 100000
               tt-carg-rural.dat-trans         = DATE(entry(16,c-linha,";"))
               tt-carg-rural.dat-entr          = TODAY
               tt-carg-rural.hra-entr          = STRING(TIME,"HH:MM:SS")
               tt-carg-rural.cdn-sit           = 1
               tt-carg-rural.qti-comptmento    = int(entry(17,c-linha,";"))
               tt-carg-rural.cod-usuario       = c-seg-usuario.
        
    END.

    /* Registro 2 - Produtor Carga */
    IF ENTRY(1,c-linha,";") = "2" THEN DO:

        ASSIGN i-seq-produtor = i-seq-produtor + 1.

        /*buscar relacionamento com carg-rural atraves da cod-carga*/
        ASSIGN i-num-carg = 0.
        FOR FIRST tt-carg-rural
            WHERE tt-carg-rural.cod-carga = entry(2,c-linha,";"):
            ASSIGN i-num-carg = tt-carg-rural.num-carg.
        END.

        IF NOT AVAIL tt-carg-rural THEN
            NEXT.

        ASSIGN i-cdn-produt-rural = INT(entry(3,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Produtor_Rural_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF i-cdn-produt-rural < 0 THEN DO:
            
                {utp/ut-liter.i "Produtor_Rural_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
                
            END.
        END.

        ASSIGN de-qtd-coleta = DEC(entry(5,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Qtd_Coleta_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF de-qtd-coleta < 0 THEN DO:
            
                {utp/ut-liter.i "Qtd_Coleta_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
                
            END.
        END.

        ASSIGN i-cdn-compart = INT(entry(6,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Compartimento_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.

        ASSIGN de-val-temperat = DEC(entry(7,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Temperatura_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.

        ASSIGN i-repos = INT(entry(9,c-linha,";")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO: 
            {utp/ut-liter.i "Reposit¢rio_aceita_somente_n£meros"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).
        END.
        ELSE DO:
            /*N∆o pode ser negativo*/
            IF i-repos < 0 THEN DO:

                {utp/ut-liter.i "Reposit¢rio_n∆o_pode_ser_negativo"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).
                
            END.
        END.
        
        ASSIGN i-cdn-motiv-nao-coleta = 0.        
        IF ENTRY(13,c-linha,";") <> "" THEN DO: 
            ASSIGN i-cdn-motiv-nao-coleta = INT(ENTRY(13,c-linha,";")) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                {utp/ut-liter.i "Motivo_n∆o_coleta_aceita_somente_n£meros"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).        
            END.
            ELSE DO:
                /*N∆o pode ser negativo*/
                IF i-cdn-motiv-nao-coleta < 0 THEN DO:
                    {utp/ut-liter.i "Motivo_n∆o_coleta_n∆o_pode_ser_negativo"}   
                    RUN pi-create-erro (INPUT RETURN-VALUE).
                END.
            END.
        END.        
          
        ASSIGN de-qtd-medid-regua = 0.
        IF ENTRY(14,c-linha,";") <> "" THEN DO:
            ASSIGN de-qtd-medid-regua = DEC(entry(14,c-linha,";")) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO:
                {utp/ut-liter.i "Medida_rÇgua_aceita_somente_n£meros"}   
                RUN pi-create-erro (INPUT RETURN-VALUE).        
            END.
            ELSE DO:
                /*N∆o pode ser negativo*/
                IF de-qtd-medid-regua  < 0 THEN DO:
                    {utp/ut-liter.i "Medida_rÇgua_n∆o_pode_ser_negativo"}   
                    RUN pi-create-erro (INPUT RETURN-VALUE).
                END.
            END.
        END.
        
        ASSIGN c-entry-data-coleta = ENTRY(15,c-linha,";") NO-ERROR.
        IF c-entry-data-coleta <> "" THEN DO:
            ASSIGN de-data-coleta = DATE(ENTRY(15,c-linha,";")) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN DO: 
                IF ERROR-STATUS:GET-NUMBER(1) = 79 THEN DO:
                    {utp/ut-liter.i "Ano_inv†lido_para_o_campo_Data_de_Coleta"}   
                    RUN pi-create-erro (INPUT RETURN-VALUE).
                END.

                IF ERROR-STATUS:GET-NUMBER(1) = 80 THEN DO:
                    {utp/ut-liter.i "Màs_inv†lido_para_o_campo_Data_de_Coleta"}   
                    RUN pi-create-erro (INPUT RETURN-VALUE).
                END.
                
                IF ERROR-STATUS:GET-NUMBER(1) = 81 THEN DO:
                    {utp/ut-liter.i "Dia_inv†lido_para_o_campo_Data_de_Coleta"}   
                    RUN pi-create-erro (INPUT RETURN-VALUE).
                END.

                IF ERROR-STATUS:GET-NUMBER(1) = 85 THEN DO:
                    {utp/ut-liter.i "Data_de_Coleta_inv†lida"}   
                    RUN pi-create-erro (INPUT RETURN-VALUE).
                END.            
            END.
        END.

        ASSIGN rRowid = ?.

        /* Ponto de Coleta Invativo */
        RUN goToKey IN h-boin00966 (INPUT ENTRY(4,c-linha,";")).
        IF RETURN-VALUE = "OK":U THEN DO:

          RUN getRowid IN h-boin00966 (OUTPUT rRowid).

          RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,     /* Aá∆o     */
                                       INPUT "PontoDeColeta":U, /* Cadastro */ 
                                       INPUT rRowid,            /* Tabela   */
                                      OUTPUT i-status,          /* Status   */
                                INPUT-OUTPUT TABLE rowErrors).

          IF i-status = 0 /* Inativo*/ THEN DO:
            {utp/ut-liter.i Ponto_de_Coleta }
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 469,
                               INPUT RETURN-VALUE + " " + ENTRY(4,c-linha,";")).
            RUN pi-create-erro(INPUT RETURN-VALUE).
          END.
        END.

        ASSIGN rRowid = ?.

        /* Produtor Invativo */
        RUN goToKey IN h-boin00962 (INPUT INT(ENTRY(3,c-linha,";"))).
        IF RETURN-VALUE = "OK":U THEN DO:

          RUN getRowid IN h-boin00962 (OUTPUT rRowid).

          RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,     /* Aá∆o     */
                                       INPUT "Produtor":U,      /* Cadastro */ 
                                       INPUT rRowid,            /* Tabela   */
                                      OUTPUT i-status,          /* Status   */
                                INPUT-OUTPUT TABLE rowErrors).

          IF i-status = 0 /* Inativo*/ THEN DO:
            {utp/ut-liter.i Produtor }
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 469,
                               INPUT RETURN-VALUE + " " + ENTRY(3,c-linha,";")).
            RUN pi-create-erro(INPUT RETURN-VALUE).
          END.
        END.

        ASSIGN rRowid = ?.
        
        /* Relacionamento - produt-pto-coleta */
        RUN goToKey  IN h-boin00990 (INPUT INT(ENTRY(3,c-linha,";")), /* cdn-produt-rural */
                                     INPUT ENTRY(4,c-linha,";"),      /* cod-pto-coleta   */
                                     INPUT ENTRY(12,c-linha,";")).    /* cod-propried     */
        IF RETURN-VALUE = "OK" THEN DO:

          RUN getRowid IN h-boin00990 (OUTPUT rRowid).

          RUN piInicial IN h-aqapi005 (INPUT "Consultar":U,       /* Aá∆o     */
                                       INPUT "produtPtoColeta":U, /* Cadastro */ 
                                       INPUT rRowid,              /* Tabela   */
                                      OUTPUT i-status,            /* Status   */
                                INPUT-OUTPUT TABLE rowErrors).
          
          IF i-status = 0 /* Inativo*/ THEN DO:
          
            FIND LAST rowErrors NO-ERROR.
            IF AVAIL rowErrors THEN
              ASSIGN i-seq = rowErrors.errorSequence + 1.
            ELSE 
              ASSIGN i-seq = 1.
            
            CREATE rowErrors.
            ASSIGN rowErrors.errorSequence    = i-seq
                   rowErrors.errorNumber      = 55219.
          
            RUN utp/ut-msgs.p (INPUT "help":U,
                               INPUT 55219,
                               INPUT STRING(ENTRY(4,c-linha,";")) + "~~" +
                                     STRING(ENTRY(3,c-linha,";"))).
          
            ASSIGN rowErrors.errorDescription = RETURN-VALUE
                   rowErrors.errorHelp        = RETURN-VALUE
                   RowErrors.ErrorType        = "EMS":U
                   RowErrors.ErrorSubType     = "ERROR":U.
          END.

        END.

        ASSIGN c-hora-convertida = ENTRY(16,c-linha,";") NO-ERROR.                
        RUN pi-converte-hora IN THIS-PROCEDURE(INPUT c-hora-convertida , OUTPUT c-hora-convertida).        

        ASSIGN c-erro-produt = "".
        FOR EACH RowErrors:
          ASSIGN c-erro-produt = c-erro-produt + RowErrors.ErrorDescription + CHR(13).
          DELETE RowErrors.
        END.
        
        IF c-erro-produt <> "" THEN DO:
            IF NOT CAN-FIND(FIRST tt-result-carg 
                            WHERE tt-result-carg.num-carg = tt-carg-rural.num-carg) THEN DO:
        
                CREATE tt-result-carg.
                ASSIGN tt-result-carg.num-carg  = tt-carg-rural.num-carg  
                       tt-result-carg.cod-carga = tt-carg-rural.cod-carga
                       tt-result-carg.cod-placa = tt-carg-rural.cod-placa
                       tt-result-carg.cod-rota  = tt-carg-rural.cod-rota 
                       tt-result-carg.situacao  = "OK".
        
            END.

            CREATE tt-result-produt.
            ASSIGN tt-result-produt.num-carg         = i-num-carg
                   tt-result-produt.cod-pto-coleta   = entry(4,c-linha,";")   
                   tt-result-produt.situacao         = "NOK"                          
                   tt-result-produt.erro-desc        = c-erro-produt.

            /*imprimir formato do campo corretamente*/
            ASSIGN de-qtd-coleta = DEC(entry(5,c-linha,";")) NO-ERROR.
            ASSIGN tt-result-produt.qtd-coleta = IF ERROR-STATUS:ERROR THEN entry(5,c-linha,";") ELSE STRING(DEC(entry(5,c-linha,";")) / 10000,"->>>>,>>>,>>9.9999").

            ASSIGN i-cdn-produt-rural = INT(entry(3,c-linha,";")) NO-ERROR.
            ASSIGN tt-result-produt.cdn-produt-rural = IF ERROR-STATUS:ERROR THEN entry(3,c-linha,";") ELSE STRING(INT(entry(3,c-linha,";")),"->>>,>>>,>>9").

            ASSIGN i-repos = INT(entry(12,c-linha,";")) NO-ERROR.
            ASSIGN tt-result-produt.cdn-repos = IF ERROR-STATUS:ERROR THEN entry(12,c-linha,";") ELSE STRING(INT(entry(12,c-linha,";")),"->>>,>>9").

            ASSIGN de-data-trans = tt-carg-rural.dat-trans NO-ERROR.
            ASSIGN tt-result-produt.dat-trans = SUBSTR(STRING(tt-carg-rural.dat-trans),1,2) + "/" + SUBSTR(STRING(tt-carg-rural.dat-trans),4,2) + "/" + SUBSTR(STRING(tt-carg-rural.dat-trans),7,4). 
            
            
            NEXT.

        END.

        CREATE tt-produt-carg.
        ASSIGN tt-produt-carg.cdn-identif            = i-seq-produtor
               tt-produt-carg.cod-estabel            = tt-carg-rural.cod-estabel
               tt-produt-carg.num-carg               = i-num-carg
               tt-produt-carg.cdn-produt-rural       = int(entry(3,c-linha,";"))            
               tt-produt-carg.cod-pto-coleta         = entry(4,c-linha,";")            
               tt-produt-carg.dat-trans              = tt-carg-rural.dat-trans
               tt-produt-carg.qtd-coleta             = dec(entry(5,c-linha,";")) / 10000
               tt-produt-carg.cdn-compart            = int(entry(6,c-linha,";"))
               tt-produt-carg.val-temperat           = dec(entry(7,c-linha,";")) / 10000         
               tt-produt-carg.des-obs                = entry(8,c-linha,";")           
               tt-produt-carg.cdn-sit                = 1
               tt-produt-carg.it-codigo              = tt-carg-rural.it-codigo           
               tt-produt-carg.cdn-repos              = int(entry(9,c-linha,";"))  
               tt-produt-carg.cod-amostra            = entry(10,c-linha,";") 
               tt-produt-carg.cod-lacre              = entry(11,c-linha,";") 
               tt-produt-carg.cod-propried           = entry(12,c-linha,";")
               tt-produt-carg.cdn-motiv-nao-coleta   = i-cdn-motiv-nao-coleta
               tt-produt-carg.qtd-medid-regua        = de-qtd-medid-regua
               tt-produt-carg.hra-coleta             = c-hora-convertida NO-ERROR.
               
        IF c-entry-data-coleta <> "" THEN       
            ASSIGN tt-produt-carg.dat-coleta = DATE(entry(15,c-linha,";")) NO-ERROR.
    END.
END.

/*Validaá∆o de Produtor Respons†vel*/
FOR EACH tt-carg-rural:
    
    FOR EACH tt-produt-carg 
       WHERE tt-produt-carg.num-carg = tt-carg-rural.num-carg
        BREAK BY tt-produt-carg.cod-pto-coleta:

        IF FIRST-OF(tt-produt-carg.cod-pto-coleta) THEN DO:
            ASSIGN l-produt-resp = NO.
        END.

        FOR FIRST produt-pto-coleta FIELDS(cdn-produt-rural) NO-LOCK
            WHERE produt-pto-coleta.cod-pto-coleta = tt-produt-carg.cod-pto-coleta
              AND produt-pto-coleta.log-respons: END.
            
        ASSIGN iProdutResposns = IF AVAIL produt-pto-coleta THEN produt-pto-coleta.cdn-produt-rural ELSE ?
               cPropriedade    = IF AVAIL produt-pto-coleta THEN produt-pto-coleta.cod-propried ELSE ''.
        IF iProdutResposns = tt-produt-carg.cdn-produt-rural THEN
            ASSIGN l-produt-resp = YES.

        /*valida respons†vel do compartimento*/
        FOR FIRST bftt-produt-carg FIELDS()
            WHERE bftt-produt-carg.num-carg         = tt-produt-carg.num-carg
              AND bftt-produt-carg.cdn-produt-rural = iProdutResposns
              AND bftt-produt-carg.cdn-compart      = tt-produt-carg.cdn-compart:
        END.

        /*Quando n∆o for encontrado produtor respons†vel para o compartimento Ç criado automaticamente a produt-carg   */
        IF NOT AVAIL bftt-produt-carg THEN DO:
            
            CREATE bftt-produt-carg.
            ASSIGN i-seq-produtor                          = i-seq-produtor + 1
                   bftt-produt-carg.cdn-identif            = i-seq-produtor
                   bftt-produt-carg.cod-estabel            = tt-carg-rural.cod-estabel
                   bftt-produt-carg.num-carg               = i-num-carg
                   bftt-produt-carg.cdn-produt-rural       = iProdutResposns            
                   bftt-produt-carg.cod-pto-coleta         = tt-produt-carg.cod-pto-coleta            
                   bftt-produt-carg.cod-propried           = cPropriedade
                   bftt-produt-carg.dat-trans              = tt-carg-rural.dat-trans
                   bftt-produt-carg.qtd-coleta             = 0
                   bftt-produt-carg.cdn-compart            = tt-produt-carg.cdn-compart
                   bftt-produt-carg.val-temperat           = dec(entry(7,c-linha,";")) / 10000         
                   bftt-produt-carg.cdn-sit                = 1
                   bftt-produt-carg.it-codigo              = tt-carg-rural.it-codigo           
                   bftt-produt-carg.cdn-repos              = tt-produt-carg.cdn-repos
                   bftt-produt-carg.cod-amostra            = entry(13,c-linha,";") 
                   bftt-produt-carg.cod-lacre              = entry(14,c-linha,";") NO-ERROR.

            /*temp-table para n∆o validar motivo de n∆o coleta quando for criado produtor automatico*/
            CREATE tt-produt-carg-automat.
            ASSIGN tt-produt-carg-automat.cdn-identif      = i-seq-produtor
                   tt-produt-carg-automat.cod-estabel      = tt-carg-rural.cod-estabel
                   tt-produt-carg-automat.num-carg         = i-num-carg
                   tt-produt-carg-automat.cdn-produt-rural = iProdutResposns
                   tt-produt-carg-automat.cod-pto-coleta   = tt-produt-carg.cod-pto-coleta.

        END.
        
    END.
    
END.


/***********************************/

/*Verifica se n∆o possui erros de importaá∆o*/
IF NOT CAN-FIND(FIRST tt-result-carg WHERE tt-result-carg.situacao = "NOK") AND NOT CAN-FIND(FIRST tt-result-produt WHERE tt-result-produt.situacao = "NOK") THEN DO:

    /*Valida e efetiva a criaá∆o da carg-rural e produt-carg*/
    RUN aqp/aqapi003.p PERSISTENT SET h-aqapi003.
    
    RUN createCarga IN h-aqapi003 (INPUT-OUTPUT TABLE tt-carg-rural,
                                   INPUT-OUTPUT TABLE tt-produt-carg,
                                   INPUT TABLE tt-produt-carg-automat).
    
    RUN getResult IN h-aqapi003 (OUTPUT TABLE tt-result-carg,
                                 OUTPUT TABLE tt-result-produt).
    
    DELETE OBJECT h-aqapi003.

END.

/*imprime resultado*/
FOR EACH tt-result-carg:

    IF tt-result-carg.erro-desc = "" THEN DO:

        disp stream str-rp 
            tt-result-carg.num-carg     
            tt-result-carg.cod-carga
            tt-result-carg.cod-placa
            tt-result-carg.cod-rota 
            tt-result-carg.situacao
            "" @ tt-result-carg.erro-desc with stream-io frame f-log.
           down stream str-rp with frame f-log.

    END.
    ELSE DO:
    
        run pi-print-editor (input tt-result-carg.erro-desc,
                             input 069).
    
        for each tt-editor:
            if  tt-editor.linha = 1 then do:
                disp stream str-rp 
                tt-result-carg.num-carg     
                tt-result-carg.cod-carga
                tt-result-carg.cod-placa
                tt-result-carg.cod-rota 
                tt-result-carg.situacao
                tt-editor.conteudo @ tt-result-carg.erro-desc with stream-io frame f-log.
               down stream str-rp with frame f-log.
            end.
            else
                put stream str-rp unformatted tt-editor.conteudo at 062 skip.
        end.
        down stream str-rp with frame f-log.

    END.

    FOR EACH tt-result-produt
       WHERE tt-result-produt.num-carg = tt-result-carg.num-carg:

        IF tt-result-produt.erro-desc = "" THEN DO:

            disp stream str-rp 
            tt-result-produt.cdn-produt-rural    
            tt-result-produt.cod-pto-coleta  
            tt-result-produt.cdn-repos       
            tt-result-produt.dat-trans       
            tt-result-produt.qtd-coleta     
            tt-result-produt.situacao
            "" @ tt-result-produt.erro-desc with stream-io frame f-log-prod.
           down stream str-rp with frame f-log-prod.


        END.
        ELSE DO:

            run pi-print-editor (input tt-result-produt.erro-desc,
                                 input 054).

            for each tt-editor:
                if  tt-editor.linha = 1 then do:
                    disp stream str-rp 
                    tt-result-produt.cdn-produt-rural    
                    tt-result-produt.cod-pto-coleta  
                    tt-result-produt.cdn-repos       
                    tt-result-produt.dat-trans       
                    tt-result-produt.qtd-coleta          
                    tt-result-produt.situacao
                    tt-editor.conteudo @ tt-result-produt.erro-desc             
                    with stream-io frame f-log-prod.
                   down stream str-rp with frame f-log-prod.
                end.
                else
                    put stream str-rp unformatted tt-editor.conteudo at 77 skip.
            end.
            down stream str-rp with frame f-log-prod.
            
        END.

    END.
    
END.
                   
page stream str-rp.

/* Impress∆o da P†gina de ParÉmetros */
CASE tt-param.destino:
    WHEN 1 THEN
        {utp/ut-liter.i Impressora * r }
    WHEN 2 THEN
        {utp/ut-liter.i Arquivo * r }
    WHEN 3 THEN
        {utp/ut-liter.i Terminal * r }
END CASE.
assign c-destino = return-value.

disp stream str-rp
     c-parametros
     tt-param.arq-entrada
     c-impressao
     c-destino 
     tt-param.arq-destino
     tt-param.usuario
   with frame f-param.

input stream s-imp close.

if  valid-handle(h-boin00961) then do:
    delete procedure h-boin00961.
    assign h-boin00961 = ?.
end.                     

if  valid-handle(h-boin00962) then do:
    delete procedure h-boin00962.
    assign h-boin00962 = ?.
end.                     

if  valid-handle(h-boin00965) then do:
    delete procedure h-boin00965.
    assign h-boin00965 = ?.
end.

if  valid-handle(h-boin00966) then do:
    delete procedure h-boin00966.
    assign h-boin00966 = ?.
end.

if  valid-handle(h-boin00990) then do:
    delete procedure h-boin00990.
    assign h-boin00990 = ?.
end.

if  valid-handle(h-aqapi005) then do:
    delete procedure h-aqapi005.
    assign h-aqapi005 = ?.
end.

/* fechamento do output de log */
{include/i-rpclo.i &STREAM="stream str-rp"}

run pi-finalizar in h-acomp.

return "OK":U.

procedure pi-print-editor:
    def input param c-editor    AS CHAR    NO-UNDO.
    def input param i-len       as integer NO-UNDO.

    DEF VAR i-linha  as integer NO-UNDO.
    DEF VAR i-aux    as integer NO-UNDO.
    DEF VAR c-aux    AS CHAR    NO-UNDO.
    DEF VAR c-ret    AS CHAR    NO-UNDO.

    /*Alteraªío 06/11/2007 - tech38629 - FO1630139 - Alteraªío para evitar que 
    o laªo entre em loop infinito quando o valor recebido como par≥metro for ? */
    IF c-editor = ? or i-len = ? THEN
        RETURN.
    /*  FO1630139 - Fim da Alteraªío */

    for each tt-editor:
        delete tt-editor.
    end.

    assign c-ret = chr(255) + chr(255).

    do  while c-editor <> "":
        if  c-editor <> "" then do:
            assign i-aux = index(c-editor, chr(10)).
            /*Alteraªío 03/08/2007 - tech14187 - FO1562655 - Alteraªío para considerar o CHR(13) como quebra de linha tamb≤m. */
            IF i-aux = 0 THEN DO:
                assign i-aux = index(c-editor, chr(13)).
            END.
            if  i-aux > i-len or (i-aux = 0 and length(c-editor) > i-len) then
                assign i-aux = r-index(c-editor, " ", i-len + 1).
            if  i-aux = 0 then
                assign c-aux = substr(c-editor, 1, i-len)
                       c-editor = substr(c-editor, i-len + 1).
            else
                assign c-aux = substr(c-editor, 1, i-aux - 1)
                       c-editor = substr(c-editor, i-aux + 1).
            if  i-len = 0 then
                assign entry(1, c-ret, chr(255)) = c-aux.
            else do:
                assign i-linha = i-linha + 1.
                create tt-editor.
                assign tt-editor.linha    = i-linha
                       tt-editor.conteudo = c-aux.
            end.
        end.
        if  i-len = 0 then
            return c-ret.
    end.
    return c-ret.
end procedure.

PROCEDURE pi-create-erro:

    DEF INPUT PARAMETER p-text AS CHAR NO-UNDO.

    create RowErrors.
    assign RowErrors.ErrorNumber      = 17006
           RowErrors.ErrorType        = "EMS":u
           RowErrors.ErrorSubType     = "ERROR":u
           RowErrors.ErrorDescription = p-text
           RowErrors.ErrorHelp        = p-text.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-create-erro-produt:

    DEF INPUT PARAMETER c-msg AS CHAR NO-UNDO.

    FOR FIRST tt-result-produt
        WHERE tt-result-produt.num-carg          = tt-carg-rural.num-carg
          AND tt-result-produt.cdn-produt-rural  = string(tt-produt-carg.cdn-produt-rural, "->>>,>>>,>>9") 
          AND tt-result-produt.cod-pto-coleta    = tt-produt-carg.cod-pto-coleta
          AND tt-result-produt.cdn-repos         = string(tt-produt-carg.cdn-repos, "->>>,>>9")
          AND tt-result-produt.dat-trans         = SUBSTR(STRING(tt-carg-rural.dat-trans),1,2) + "/" + SUBSTR(STRING(tt-carg-rural.dat-trans),4,2) + "/" + SUBSTR(STRING(tt-carg-rural.dat-trans),7,4):
        ASSIGN tt-result-produt.erro-desc = tt-result-produt.erro-desc + c-msg + CHR(13).
    END.
    IF NOT AVAIL tt-result-produt THEN DO:

        IF NOT CAN-FIND(FIRST tt-result-carg 
                        WHERE tt-result-carg.num-carg = tt-carg-rural.num-carg) THEN DO:

            CREATE tt-result-carg.
            ASSIGN tt-result-carg.num-carg  = tt-carg-rural.num-carg  
                   tt-result-carg.cod-carga = tt-carg-rural.cod-carga
                   tt-result-carg.cod-placa = tt-carg-rural.cod-placa
                   tt-result-carg.cod-rota  = tt-carg-rural.cod-rota 
                   tt-result-carg.situacao  = "OK".
    
        END.

        CREATE tt-result-produt.
        ASSIGN tt-result-produt.num-carg         = tt-produt-carg.num-carg
               tt-result-produt.cdn-produt-rural = string(tt-produt-carg.cdn-produt-rural, "->>>,>>>,>>9") 
               tt-result-produt.cod-pto-coleta   = tt-produt-carg.cod-pto-coleta   
               tt-result-produt.cdn-repos        = string(tt-produt-carg.cdn-repos, "->>>,>>9")
               tt-result-produt.dat-trans        = SUBSTR(STRING(tt-carg-rural.dat-trans),1,2) + "/" + SUBSTR(STRING(tt-carg-rural.dat-trans),4,2) + "/" + SUBSTR(STRING(tt-carg-rural.dat-trans),7,4)
               tt-result-produt.qtd-coleta       = string(tt-produt-carg.qtd-coleta, ">>>>,>>>,>>9.9999")       
               tt-result-produt.situacao         = "NOK"
               tt-result-produt.erro-desc        = c-msg + CHR(13) NO-ERROR.
        
        
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-converte-hora:
/*------------------------------------------------------------------------------
  Purpose: Coverter hora coleta.
  Parameters:  p-hora: hora coleta
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-hora  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER c-hora AS CHARACTER NO-UNDO.   
    
    DEFINE VARIABLE i-hora-coleta AS INTEGER            NO-UNDO.
    DEFINE VARIABLE l-erro        AS LOGICAL INITIAL NO NO-UNDO.
    
    IF p-hora <> "" THEN DO:    
        ASSIGN i-hora-coleta = INT(p-hora) NO-ERROR.    
        IF ERROR-STATUS:ERROR THEN DO:
            {utp/ut-liter.i "Hora_coleta_aceita_somente_n£meros_no_formato_hhmmss"}   
            RUN pi-create-erro (INPUT RETURN-VALUE).   
            ASSIGN l-erro = YES.
        END.
        ELSE DO:
            IF LENGTH(p-hora) <> 6 THEN DO:
                {utp/ut-liter.i "Hora_deve_conter_6_d°gitos_no_formato_hhmmss"} 
                RUN pi-create-erro (INPUT RETURN-VALUE). 
                ASSIGN l-erro = YES.
            END.
            ELSE DO:
                /* Valida hora */
                IF INT(SUBSTR(p-hora, 1, 2)) < 0  OR INT(SUBSTR(p-hora, 1, 2)) > 23 THEN DO:
                    {utp/ut-liter.i "Hora_deve_ser_maior_ou_igual_a_00_e_menor_que_24_em_hora_coleta"} 
                    RUN pi-create-erro (INPUT RETURN-VALUE).   
                    ASSIGN l-erro = YES.
                END.
                
                /* Valida minutos */
                IF INT(SUBSTR(p-hora, 3, 2)) < 0  OR INT(SUBSTR(p-hora, 3, 2)) > 59 THEN DO:
                    {utp/ut-liter.i "Minuto_deve_ser_maior_ou_igual_a_00_e_menor_que_60_em_hora_coleta"} 
                    RUN pi-create-erro (INPUT RETURN-VALUE). 
                    ASSIGN l-erro = YES.                
                END.
                
                /* Valida segundos */
                IF INT(SUBSTR(p-hora, 5, 2)) < 0  OR INT(SUBSTR(p-hora, 5, 2)) > 59 THEN DO:
                    {utp/ut-liter.i "Segundo_deve_ser_maior_ou_igual_a_00 _e_menor_que_60_em_hora_coleta"} 
                    RUN pi-create-erro (INPUT RETURN-VALUE).       
                    ASSIGN l-erro = YES.
                END.        
            END.
        END.        
        IF l-erro THEN
            RETURN "NOK":U.
        
        ASSIGN c-hora = p-hora.
    END.    
    
    RETURN "OK":U.
END PROCEDURE.

/* CD0192RP.P */
    
