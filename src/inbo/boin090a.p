/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN090A 2.00.00.026 } /*** "010026" 10/04/2026 11:05:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin090a MUT}
&ENDIF

/*******************************************************************************
**
**  BOIN090a.P
**
**  Docum-est - Cria tt-docum-est-rateio, apartir do embarque e estabelecimento, 
**              e se o docum-est.ce-atual = yes, relaciona tambem as notas de 
**              rateio. 
*******************************************************************************/

&scoped-define BOVERSION 1.1
&scoped-define PRVERSION 2.00.00.000
&scoped-define FIRST-TABLE-IN-QUERY tt-docum-est-rateio
&scoped-define QUERY-NAME qTable
&scoped-define TABLE-NAME tt-docum-est-rateio

{include/boini.i}
{method/dbotterr.i}
{cdp/cdcfgmat.i} /* defini‡Æo pr‚-processador */
{cdp/cdcfgdis.i}
{cdp/cd4300.i3}
{rep/re1001a.i50}

DEFINE TEMP-TABLE RowObject no-undo like docum-est
    field r-rowid   as rowid
    field nome-abrev as char format "x(12)".
    
DEFINE TEMP-TABLE tt-docum-est-rateio no-undo like docum-est
    field r-rowid    as rowid
    field nome-abrev as char format "x(12)".  
    
DEFINE TEMP-TABLE tt-documentos NO-UNDO
    field embarque                   LIKE embarque-imp.embarque      
    field cod-estabel                LIKE embarque-imp.cod-estabel   
    field nro-docto                  LIKE docum-est.nro-docto
    field serie-docto                LIKE docum-est.serie-docto   
    field cod-emitente               LIKE docum-est.cod-emitente
    field nat-operacao               LIKE docum-est.nat-operacao
    field idi-nf-simples-remes       LIKE docum-est.idi-nf-simples-remes
    field dt-emissao                 LIKE docum-est.dt-emissao
    field usuario                    LIKE docum-est.usuario                          
    field ce-atual                   LIKE docum-est.ce-atual	
    field embarque-ori               LIKE embarque-imp.embarque
    field log-nota-ajust-import      LIKE item-doc-est.log-nota-ajust-import
    field cod-tipo-nf-cred-deb       LIKE docum-est.cod-tipo-nf-cred-deb
    field cod-finalidade             LIKE docum-est.cod-finalidade
    FIELD observ-pagto               AS CHAR
    field r-rowid as rowid
.     

DEFINE QUERY {&QUERY-NAME} for {&TABLE-NAME} scrolling.

def var c-nr-proc-imp   as char    no-undo. 
def var c-cod-estabel   as char    no-undo.
def var c-idioma        AS char    no-undo.
def var i-cod-emitente  AS integer no-undo.
def var c-par           AS char    no-undo.
def var da-emis         as date    no-undo.
def var de-quant        as decimal no-undo.
def var de-valor        as decimal no-undo.
def var i-var           as integer no-undo.
def var de-item         as integer no-undo.
def var l-spp-NT2024002 AS LOG NO-UNDO.
ASSIGN l-spp-NT2024002 = CAN-FIND(FIRST funcao NO-LOCK
                                  WHERE funcao.cd-funcao = "spp-NT2024002"
                                  AND   funcao.ativo).
                                  
def buffer b-docum-est for docum-est.
def buffer b-docum-est-aux for docum-est.
def buffer b-docum-est-antecip FOR docum-est.
def buffer b-embarque-imp for embarque-imp.

procedure setConstraint1:

end procedure.

procedure setConstraint2:
    def input parameter p-cod-estabel as char no-undo.
end procedure.

procedure CriaTTDocumEstRateio:

def input parameter p-cod-estabel as char    no-undo.
def input parameter p-embarque    as char    no-undo.

DEF VAR c-nome-abrev       AS CHAR FORMAT "x(12)" NO-UNDO.    
DEF VAR i-documento        AS INT                 NO-UNDO.
DEF VAR l-emitente         AS LOG INITIAL NO      NO-UNDO.
DEF VAR l-estabel          AS LOG INITIAL NO      NO-UNDO.
DEF VAR l-spp-busca-so-emb AS LOG INITIAL NO      NO-UNDO.

    ASSIGN l-spp-busca-so-emb = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-busca-so-emb":U
                                                        AND funcao.ativo     = YES).

    for each tt-docum-est-rateio :
        delete tt-docum-est-rateio.
    end.
    
    FOR FIRST ordens-embarque FIELDS(numero-ordem cod-estabel embarque) WHERE
              ordens-embarque.cod-estabel = p-cod-estabel AND
              ordens-embarque.embarque    = p-embarque    NO-LOCK:
    END.
    IF NOT AVAIL ordens-embarque THEN LEAVE.

    FIND ordem-compra WHERE
         ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-LOCK NO-ERROR.
    
    IF NOT AVAIL ordem-compra THEN LEAVE.

    ASSIGN i-documento = 0
           l-emitente  = NO
           l-estabel   = NO.

    IF NOT l-spp-busca-so-emb THEN DO:
        
        for each docum-est fields (cod-emitente serie-docto nro-docto cod-estabel dt-emissao nat-operacao ce-atual char-1 idi-nf-simples-remes usuario) where
                 docum-est.cod-emitente = ordem-compra.cod-emitente NO-LOCK
            USE-INDEX emitente:
            ASSIGN i-documento = 1.
            {inbo/boin090a.i} /*include responsavel por buscar as notas de rateio*/
        end.
    
        IF NOT l-emitente THEN DO:
            for each docum-est fields (cod-emitente serie-docto nro-docto cod-estabel dt-emissao nat-operacao ce-atual char-1 idi-nf-simples-remes usuario) where
                     docum-est.cod-estabel = ordens-embarque.cod-estabel NO-LOCK:
                ASSIGN i-documento = 2.
                {inbo/boin090a.i} /*include responsavel por buscar as notas de rateio*/
            end.
        END.
    END.

    IF  NOT l-emitente
    AND NOT l-estabel THEN DO:
        for each docum-est fields (cod-emitente serie-docto nro-docto cod-estabel dt-emissao nat-operacao ce-atual char-1 idi-nf-simples-remes usuario) where
                 trim(substring(docum-est.char-1,1,20)) = ordens-embarque.embarque NO-LOCK:
            {inbo/boin090a.i} /*include responsavel por buscar as notas de rateio*/
       end.
    END.

end procedure.

PROCEDURE pi-retorna-documentos:
    def input parameter  p-cod-estabel      as char    no-undo.
    def input parameter  p-embarque         as char    no-undo.
    DEF OUTPUT PARAMETER TABLE FOR tt-documentos.
    DEF OUTPUT PARAMETER TABLE FOR RowErrors.

    EMPTY TEMP-TABLE tt-documentos.
    EMPTY TEMP-TABLE RowErrors.

    FOR EACH embarq-import-docto FIELDS (cod-estab cod-embarq cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
        WHERE embarq-import-docto.cod-estab   = p-cod-estabel
          AND embarq-import-docto.cod-embarq  = p-embarque    NO-LOCK,
        FIRST docum-est 
        WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto   
          AND docum-est.nro-docto    = embarq-import-docto.cod-docto       
          AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente    
          AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:

        FOR FIRST natur-oper FIELDS(nat-operacao nota-rateio) NO-LOCK
            WHERE natur-oper.nat-operacao = docum-est.nat-operacao:
        END.
        IF NOT AVAIL natur-oper OR (AVAIL natur-oper AND natur-oper.nota-rateio) THEN NEXT.

        CREATE tt-documentos.
        BUFFER-COPY docum-est TO tt-documentos.
        ASSIGN tt-documentos.cod-estabel  = embarq-import-docto.cod-estab 
               tt-documentos.embarque     = embarq-import-docto.cod-embarq
               tt-documentos.embarque-ori = p-embarque
               tt-documentos.r-rowid = ROWID(docum-est).

        FIND FIRST item-doc-est 
             WHERE item-doc-est.serie-docto     = docum-est.serie-docto
               AND item-doc-est.nro-docto       = docum-est.nro-docto    
               AND item-doc-est.cod-emitente    = docum-est.cod-emitente 
               AND item-doc-est.nat-operacao    = docum-est.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL item-doc-est THEN
           ASSIGN tt-documentos.log-nota-ajust-import = item-doc-est.log-nota-ajust-import.

        RUN cria-nf-complementar (INPUT embarq-import-docto.cod-ser-docto,   
                                  INPUT embarq-import-docto.cod-docto,       
                                  INPUT embarq-import-docto.cdn-emitente,    
                                  INPUT embarq-import-docto.cod-natur-operac,
                                  INPUT embarq-import-docto.cod-embarq,
                                  INPUT embarq-import-docto.cod-estab,
                                  INPUT p-embarque).

        IF  l-spp-NT2024002 THEN DO:
            RUN cria-nf-pagto-antecip (INPUT embarq-import-docto.cod-ser-docto,
                                       INPUT embarq-import-docto.cod-docto,
                                       INPUT embarq-import-docto.cdn-emitente,
                                       INPUT embarq-import-docto.cod-natur-operac,
                                       INPUT embarq-import-docto.cod-embarq,
                                       INPUT embarq-import-docto.cod-estab,
                                       INPUT p-embarque).
        END.
    END.

    /*Se nÆo encontrar registro na embarq-import-docto e embarque possuir entregas recebidas dever  direcionar 
      para a execu‡Æo do spim039 para cria‡Æo do relacionamento Embarque X Notas Fiscais*/

    IF NOT CAN-FIND(FIRST tt-documentos) THEN DO:
        FOR FIRST ordens-embarque FIELDS(numero-ordem parcela)
            WHERE ordens-embarque.cod-estabel = p-cod-estabel
              AND ordens-embarque.embarque  = p-embarque NO-LOCK:

             IF CAN-FIND(FIRST prazo-compra 
                           WHERE prazo-compra.numero-ordem = ordens-embarque.numero-ordem 
                             AND prazo-compra.parcela      = ordens-embarque.parcela
                             AND prazo-compra.situacao = 6 /*recebida*/) THEN DO:
                CREATE RowErrors.
                ASSIGN RowErrors.ErrorSequence = 1.
                ASSIGN RowErrors.ErrorNumber  = 55448.
        
                RUN utp/ut-msgs.p (INPUT "msg",
                                   INPUT 55448,
                                   INPUT p-embarque).
                ASSIGN RowErrors.ErrorDescription  = RETURN-VALUE.
        
                RUN utp/ut-msgs.p (INPUT "help",
                                   INPUT 55448,
                                   INPUT p-embarque).
                ASSIGN RowErrors.ErrorHelp = RETURN-VALUE
                       RowErrors.ErrorParameters = p-embarque
                       RowErrors.ErrorType = "EMS":U
                       RowErrors.ErrorSubType = "QUESTION":U.
             END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE cria-nf-complementar:
    define input parameter p-serie         like docum-est.serie-docto    no-undo.
    define input parameter p-nro-docto     like docum-est.nro-docto      no-undo. 
    define input parameter p-cod-emitente  like docum-est.cod-emitente   no-undo. 
    define input parameter p-nat-operacao  like docum-est.nat-operacao   no-undo. 
    define input parameter p-embarque      like embarque-imp.embarque    no-undo. 
    define input parameter p-cod-estabel   like embarque-imp.cod-estabel no-undo. 
    define input parameter p-embarque-orig like embarque-imp.embarque    no-undo. 

    FOR EACH rat-docum FIELDS(nf-serie nf-nro nf-emitente nf-nat-oper serie-docto nro-docto cod-emitente nat-operacao)
       WHERE rat-docum.nf-serie    = p-serie
         AND rat-docum.nf-nro      = p-nro-docto
         AND rat-docum.nf-emitente = p-cod-emitente
         AND rat-docum.nf-nat-oper = p-nat-operacao NO-LOCK USE-INDEX nf-docto:

        FOR EACH b-docum-est-aux 
           WHERE b-docum-est-aux.serie-docto  = rat-docum.serie-docto
             AND b-docum-est-aux.nro-docto    = rat-docum.nro-docto
             AND b-docum-est-aux.cod-emitente = rat-docum.cod-emitente
             AND b-docum-est-aux.nat-operacao = rat-docum.nat-operacao NO-LOCK USE-INDEX documento:

            FIND tt-documentos WHERE
                 tt-documentos.serie-docto  = b-docum-est-aux.serie-docto AND  
                 tt-documentos.nro-docto    = b-docum-est-aux.nro-docto AND 
                 tt-documentos.cod-emitente = b-docum-est-aux.cod-emitente AND
                 tt-documentos.nat-operacao = b-docum-est-aux.nat-operacao NO-ERROR.
            IF NOT AVAIL tt-documentos THEN DO:
                CREATE tt-documentos.
                BUFFER-COPY b-docum-est-aux TO tt-documentos.
                ASSIGN tt-documentos.cod-estabel  = p-cod-estabel
                       tt-documentos.embarque     = p-embarque
                       tt-documentos.embarque-ori = p-embarque-orig.
                       tt-documentos.r-rowid = ROWID(b-docum-est-aux).
                      
                IF  l-spp-NT2024002 THEN DO:
                    RUN cria-nf-pagto-antecip (INPUT b-docum-est-aux.serie-docto,
                                               INPUT b-docum-est-aux.nro-docto,
                                               INPUT b-docum-est-aux.cod-emitente,
                                               INPUT b-docum-est-aux.nat-operacao,
                                               INPUT p-embarque,
                                               INPUT b-docum-est-aux.cod-estabel,
                                               INPUT p-embarque-orig).
                END.
            END.
        END.
    END.

    RETURN "OK":U.
end PROCEDURE.

PROCEDURE cria-nf-pagto-antecip:
    define input parameter p-serie         like docum-est.serie-docto    no-undo.
    define input parameter p-nro-docto     like docum-est.nro-docto      no-undo. 
    define input parameter p-cod-emitente  like docum-est.cod-emitente   no-undo. 
    define input parameter p-nat-operacao  like docum-est.nat-operacao   no-undo. 
    define input parameter p-embarque      like embarque-imp.embarque    no-undo. 
    define input parameter p-cod-estabel   like embarque-imp.cod-estabel no-undo. 
    define input parameter p-embarque-orig like embarque-imp.embarque    no-undo. 
    
    FOR EACH nota-fisc-adc NO-LOCK
        WHERE nota-fisc-adc.cod-estab        = p-cod-estabel
        AND   nota-fisc-adc.cod-serie        = p-serie
        AND   nota-fisc-adc.cod-nota-fisc    = p-nro-docto
        AND   nota-fisc-adc.cdn-emitente     = p-cod-emitente
        AND   nota-fisc-adc.cod-natur-operac = p-nat-operacao
        AND   nota-fisc-adc.idi-tip-dado     = 3: /* Docto Fiscal Referenciado */

        FOR FIRST b-docum-est-antecip NO-LOCK
            WHERE  b-docum-est-antecip.cod-estabel  = nota-fisc-adc.cod-estab
            AND    b-docum-est-antecip.serie-docto  = nota-fisc-adc.cod-ser-docto-referado
            AND    b-docum-est-antecip.nro-docto    = nota-fisc-adc.cod-docto-referado
            AND    b-docum-est-antecip.cod-emitente = nota-fisc-adc.cdn-emit-docto-referado
            AND    b-docum-est-antecip.dt-emissao   = nota-fisc-adc.dat-docto-referado:
        END.

        IF  AVAIL b-docum-est-antecip
        AND b-docum-est-antecip.cod-tipo-nf-cred-deb = "6" /* Nota de D‚bito */
        AND b-docum-est-antecip.cod-finalidade       = "6" /* Pagamento Antecipado */ THEN DO:
        
            FIND FIRST emitente NO-LOCK
                WHERE emitente.cod-emitente = p-cod-emitente NO-ERROR.

            CREATE tt-documentos.
            ASSIGN tt-documentos.nro-docto            = nota-fisc-adc.cod-docto-referado
                   tt-documentos.serie-docto          = nota-fisc-adc.cod-ser-docto-referado
                   tt-documentos.cod-emitente         = nota-fisc-adc.cdn-emit-docto-referado
                   tt-documentos.nat-operacao         = b-docum-est-antecip.nat-operacao
                   tt-documentos.dt-emissao           = b-docum-est-antecip.dt-emissao
                   tt-documentos.usuario              = b-docum-est-antecip.usuario
                   tt-documentos.ce-atual             = b-docum-est-antecip.ce-atual
                   tt-documentos.cod-tipo-nf-cred-deb = b-docum-est-antecip.cod-tipo-nf-cred-deb
                   tt-documentos.cod-finalidade       = b-docum-est-antecip.cod-finalidade
                   tt-documentos.cod-estabel          = p-cod-estabel
                   tt-documentos.embarque             = p-embarque
                   tt-documentos.embarque-ori         = p-embarque-orig
                   tt-documentos.r-rowid              = ROWID(b-docum-est-antecip)
                   tt-documentos.observ-pagto         = "Referente NF " 
                                                      + TRIM(p-cod-estabel) + "/" 
                                                      + TRIM(p-serie) + "/"
                                                      + TRIM(p-nat-operacao) + "/"
                                                      + TRIM(p-nro-docto) + "/"
                                                      + (IF AVAIL emitente THEN TRIM(emitente.nome-abrev) ELSE "").
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

procedure openQuery:
    define input parameter i-abertura as integer no-undo.
    case i-abertura:
        when 1 then 
            open query {&QUERY-NAME} for each {&TABLE-NAME} no-lock.
        when 2 then do:
            open query {&QUERY-NAME} for each tt-docum-est-rateio no-lock.        
        end.
    end case.
    assign l-query    = true
           i-bo-query = i-abertura.
end procedure.

{include/bostrmet.i}
{include/boendmet.i}
{include/bocomver.i}
{include/bogetver.i}
{include/bonav.i}
{include/bofind.i}
/*{include/bosetcur.i}*/
{include/bogetcur.i}

procedure setCurrent:
    /*
    **  Seta registro corrente para a temp-table que sera devolvida.
    */
    for each RowObject:
        delete RowObject.
    end.
    if avail {&TABLE-NAME} then do:
        create RowObject.
        buffer-copy {&TABLE-NAME} to RowObject.
    end.
end procedure.


procedure initializeValidate:
    /*
    **  Inicializa Validate
    */
     
    run startMethod ("initializeValidade").
 
    run endMethod   ("initializeValidade").
end procedure.
 
procedure serverSendRows :
    /*
    **  Disponivel no smart data object da V9, e foi reimplementado dentro
    **  da versao 8. Faz consultas utilizando a querie dentro da smartquery,
    **  possibilitando que clientes WebSpeed acessem esta mesma smart-query
    **  e facilitara a migracao destes programas para os Smart Data Objects.
    */
    define input  parameter piStartRow     as  integer   no-undo.
    define input  parameter pcRowIdent     as  character no-undo.
    define input  parameter plNext         as  logical   no-undo.
    define input  parameter piRowsToReturn as  integer   no-undo.
    define output parameter piRowsReturned as  integer   no-undo.
    define output parameter table          for RowObject.
 
    define variable hQuery        as handle    no-undo.
    define variable hBuffer       as handle    no-undo.
    define variable hRowObject    as handle    no-undo.
    define variable hDataQuery    as handle    no-undo.
    define variable cRowIdent     as character no-undo.
    define variable rRowIDs       as rowid     extent 10 no-undo.
    define variable lOK           as logical   no-undo.
    define variable iRow          as integer   no-undo.
 
    for each rowObject:
        delete rowObject.
    end.
    IF true THEN DO:
        IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN DO:
            rRowIDs = ?.
            reposition {&query-name} to rowid to-rowid(pcRowIdent).
            get next {&query-name}.
        END.
        ELSE IF piStartRow NE ? AND piStartRow NE 0 THEN DO:
            REPOSITION  {&query-name} TO ROW piStartRow.
            GET next {&query-name}.
        END.
        IF plNext THEN
            GET next {&query-name}.
        DO WHILE true:
            if available({&first-table-in-query})  and piRowsReturned < piRowsToReturn then do:
                create rowObject.
                buffer-copy {&table-name} to rowObject.
                assign rowObject.r-rowid    = rowid({&table-name}).
                GET NEXT {&query-name}.
                piRowsReturned = piRowsReturned + 1.
            end.
            else
                leave.
        END.
        IF piRowsReturned > 0 THEN DO:
            {&open-query}
            IF piStartRow = ? OR piStartRow = 0 THEN DO:
                get first {&query-name}.
                get prev {&query-name}.
            END.
            ELSE
                REPOSITION  {&query-name} TO ROW (piStartRow).
        END.
    END.
    RETURN.
end procedure.
 
procedure prevBrowseNavigation:
    /*
    **  Usado na navegação anterior do serverSendRows 
    */
    def input parameter c-rowid-atual as char no-undo.
    def input parameter i-linhas-prev as integer no-undo.
    def output parameter c-rowid-ant as char no-undo.
 
    def var i-cont as integer no-undo.
 
    reposition {&query-name} to rowid to-rowid(c-rowid-atual).
 
    do while (i-cont < (i-linhas-prev - 1)):
       get prev {&query-name}.
       assign i-cont = i-cont + 1.
    end.
    assign c-rowid-ant = string({&table-name}.r-rowid).
end procedure.
 
procedure retornaTTDocumEstRateio:
    def output param table for tt-docum-est-rateio.
    
    find first tt-docum-est-rateio no-error.
end procedure.

procedure getCharField:
    define input  parameter c-field as char.
    define output parameter c-value as char.
 
    case c-field:
        when "c-nr-invoice" then c-value = RowObject.c-nr-invoice.
        when "char-1" then c-value = RowObject.char-1.
        when "char-2" then c-value = RowObject.char-2.
        
        when "nome-abrev" then c-value = RowObject.nome-abrev.
        when "cod-estabel" then c-value = RowObject.cod-estabel.
        when "cod-imp-irf" then c-value = RowObject.cod-imp-irf.
        &if defined(bf-mat-comex) &then
           when "esp-docto" then c-value = RowObject.esp-docto.        
        &else
           when "nro-docto" then c-value = RowObject.nro-docto.
           when "ok-observ" then c-value = RowObject.ok-observ.
           when "check-sum" then c-value = RowObject.check-sum.
           when "ct-transit" then c-value = RowObject.ct-transit.           
           when "sc-transit" then c-value = RowObject.sc-transit.           
        &endif

        when "embalagem" then c-value = RowObject.embalagem.
        when "esp-irf" then c-value = RowObject.esp-irf.
        when "estab-de-or" then c-value = RowObject.estab-de-or.
        when "estab-fisc" then c-value = RowObject.estab-fisc.
        when "hr-atualiza" then c-value = RowObject.hr-atualiza.
        when "nat-operacao" then c-value = RowObject.nat-operacao.
        when "observacao" then c-value = RowObject.observacao.
        when "ok-user" then c-value = RowObject.ok-user.
        when "origem" then c-value = RowObject.origem.
        when "pais-origem" then c-value = RowObject.pais-origem.
        when "serie-docto" then c-value = RowObject.serie-docto.
        when "uf" then c-value = RowObject.uf.
        when "usuario" then c-value = RowObject.usuario.
        WHEN "cod-finalidade":U THEN c-value = RowObject.cod-finalidade.
        when "cod-modalid-frete":U then c-value = &if '{&BF_DIS_VERSAO_EMS}' >= '2.09'
                                                  &then RowObject.cod-modalid-frete.
                                                  &else substring(RowObject.char-2,143,8).
                                                  &endif
        WHEN "tipo-dfe-docto":U THEN ASSIGN c-value = RowObject.tipo-dfe-docto.
        otherwise return error.
    end case.
end procedure.
 
procedure getDecField:
    define input  parameter c-field as char.
    define output parameter c-value as decimal.
 
    case c-field:
        when "aliq-irf" then c-value = RowObject.aliq-irf.
        when "aliquota-icm" then c-value = RowObject.aliquota-icm.
        when "aliquota-iss" then c-value = RowObject.aliquota-iss.
        when "base-icm" then c-value = RowObject.base-icm.
        when "base-icm-fas[1]" then c-value = RowObject.base-icm-fas[1].
        when "base-icm-fas[2]" then c-value = RowObject.base-icm-fas[2].
        when "base-ipi" then c-value = RowObject.base-ipi.
        when "base-ipi-fas[1]" then c-value = RowObject.base-ipi-fas[1].
        when "base-ipi-fas[2]" then c-value = RowObject.base-ipi-fas[2].
        when "base-iss" then c-value = RowObject.base-iss.
        when "base-iss-fas[1]" then c-value = RowObject.base-iss-fas[1].
        when "base-iss-fas[2]" then c-value = RowObject.base-iss-fas[2].
        when "base-subs" then c-value = RowObject.base-subs.
        when "base-subs-fasb[1]" then c-value = RowObject.base-subs-fasb[1].
        when "base-subs-fasb[2]" then c-value = RowObject.base-subs-fasb[2].
        
        &if defined(bf-mat-comex) &then
        &else
           when "cotacao-dia" then c-value = RowObject.cotacao-dia.
           when "despesa-nota-me" then c-value = RowObject.despesa-nota-me.           
           when "tot-desconto-me" then c-value = RowObject.tot-desconto-me.
           when "tot-taxa" then c-value = RowObject.tot-taxa.
           when "tot-taxa-me" then c-value = RowObject.tot-taxa-me.
           when "tot-valor-me" then c-value = RowObject.tot-valor-me.
           when "valor-embal-me" then c-value = RowObject.valor-embal-me.
           when "valor-mercad-me" then c-value = RowObject.valor-mercad-me.
           when "valor-seguro-me" then c-value = RowObject.valor-seguro-me.
           when "valor-frete-me" then c-value = RowObject.valor-frete-me.
           when "valor-outras-me" then c-value = RowObject.valor-outras-me.
        &endif        
        when "cotacao-fasb" then c-value = RowObject.cotacao-fasb.
        when "dec-1" then c-value = RowObject.dec-1.
        when "dec-2" then c-value = RowObject.dec-2.
        when "desp-fasb[1]" then c-value = RowObject.desp-fasb[1].
        when "desp-fasb[2]" then c-value = RowObject.desp-fasb[2].
        when "despesa-nota" then c-value = RowObject.despesa-nota.

        when "icm-complem" then c-value = RowObject.icm-complem.
        when "icm-cpl-fasb[1]" then c-value = RowObject.icm-cpl-fasb[1].
        when "icm-cpl-fasb[2]" then c-value = RowObject.icm-cpl-fasb[2].
        when "icm-dc-fasb[1]" then c-value = RowObject.icm-dc-fasb[1].
        when "icm-dc-fasb[2]" then c-value = RowObject.icm-dc-fasb[2].
        when "icm-deb-cre" then c-value = RowObject.icm-deb-cre.
        when "icm-fnt-fasb[1]" then c-value = RowObject.icm-fnt-fasb[1].
        when "icm-fnt-fasb[2]" then c-value = RowObject.icm-fnt-fasb[2].
        when "icm-fonte" then c-value = RowObject.icm-fonte.
        when "icm-nao-trib" then c-value = RowObject.icm-nao-trib.
        when "icm-ntr-fasb[1]" then c-value = RowObject.icm-ntr-fasb[1].
        when "icm-ntr-fasb[2]" then c-value = RowObject.icm-ntr-fasb[2].
        when "icm-out-fasb[1]" then c-value = RowObject.icm-out-fasb[1].
        when "icm-out-fasb[2]" then c-value = RowObject.icm-out-fasb[2].
        when "icm-outras" then c-value = RowObject.icm-outras.
        when "imp-import" then c-value = RowObject.imp-import.
        when "ipi-dc-fasb[1]" then c-value = RowObject.ipi-dc-fasb[1].
        when "ipi-dc-fasb[2]" then c-value = RowObject.ipi-dc-fasb[2].
        when "ipi-deb-cre" then c-value = RowObject.ipi-deb-cre.
        when "ipi-despesa" then c-value = RowObject.ipi-despesa.
        when "ipi-nao-trib" then c-value = RowObject.ipi-nao-trib.
        when "ipi-ntr-fasb[1]" then c-value = RowObject.ipi-ntr-fasb[1].
        when "ipi-ntr-fasb[2]" then c-value = RowObject.ipi-ntr-fasb[2].
        when "ipi-out-fasb[1]" then c-value = RowObject.ipi-out-fasb[1].
        when "ipi-out-fasb[2]" then c-value = RowObject.ipi-out-fasb[2].
        when "ipi-outras" then c-value = RowObject.ipi-outras.
        when "iss-dc-fasb[1]" then c-value = RowObject.iss-dc-fasb[1].
        when "iss-dc-fasb[2]" then c-value = RowObject.iss-dc-fasb[2].
        when "iss-deb-cre" then c-value = RowObject.iss-deb-cre.
        when "iss-nao-trib" then c-value = RowObject.iss-nao-trib.
        when "iss-ntr-fasb[1]" then c-value = RowObject.iss-ntr-fasb[1].
        when "iss-ntr-fasb[2]" then c-value = RowObject.iss-ntr-fasb[2].
        when "iss-out-fasb[1]" then c-value = RowObject.iss-out-fasb[1].
        when "iss-out-fasb[2]" then c-value = RowObject.iss-out-fasb[2].
        when "iss-outras" then c-value = RowObject.iss-outras.
        /*when "perc-tax-div" then c-value = RowObject.perc-tax-div.
        when "perc-tax-fre" then c-value = RowObject.perc-tax-fre.*/
        when "qt-tot-imp" then c-value = RowObject.qt-tot-imp.
        when "taxa-conv-imp" then c-value = RowObject.taxa-conv-imp.
        when "tot-des-fasb[1]" then c-value = RowObject.tot-des-fasb[1].
        when "tot-des-fasb[2]" then c-value = RowObject.tot-des-fasb[2].
        when "tot-desconto" then c-value = RowObject.tot-desconto.
        
        when "tot-peso" then c-value = RowObject.tot-peso.
        when "tot-valor" then c-value = RowObject.tot-valor.
        when "tot-vl-fasb[1]" then c-value = RowObject.tot-vl-fasb[1].
        when "tot-vl-fasb[2]" then c-value = RowObject.tot-vl-fasb[2].
        when "valor-embal" then c-value = RowObject.valor-embal.

        when "valor-frete" then c-value = RowObject.valor-frete.
        
        when "valor-irf" then c-value = RowObject.valor-irf.
        when "valor-mercad" then c-value = RowObject.valor-mercad.
        
        when "valor-outras" then c-value = RowObject.valor-outras.
        
        when "valor-seguro" then c-value = RowObject.valor-seguro.
        
        when "vl-emb-fasb[1]" then c-value = RowObject.vl-emb-fasb[1].
        when "vl-emb-fasb[2]" then c-value = RowObject.vl-emb-fasb[2].
        when "vl-fre-fasb[1]" then c-value = RowObject.vl-fre-fasb[1].
        when "vl-fre-fasb[2]" then c-value = RowObject.vl-fre-fasb[2].
        when "vl-imp-impor[1]" then c-value = RowObject.vl-imp-impor[1].
        when "vl-imp-impor[2]" then c-value = RowObject.vl-imp-impor[2].
        when "vl-merc-fasb[1]" then c-value = RowObject.vl-merc-fasb[1].
        when "vl-merc-fasb[2]" then c-value = RowObject.vl-merc-fasb[2].
        when "vl-out-fasb[1]" then c-value = RowObject.vl-out-fasb[1].
        when "vl-out-fasb[2]" then c-value = RowObject.vl-out-fasb[2].
        when "vl-seg-fasb[1]" then c-value = RowObject.vl-seg-fasb[1].
        when "vl-seg-fasb[2]" then c-value = RowObject.vl-seg-fasb[2].
        when "vl-subs" then c-value = RowObject.vl-subs.
        when "vl-subs-fasb[1]" then c-value = RowObject.vl-subs-fasb[1].
        when "vl-subs-fasb[2]" then c-value = RowObject.vl-subs-fasb[2].
        /*when "vl-tax-diversos" then c-value = RowObject.vl-tax-diversos.
        when "vl-tax-frete" then c-value = RowObject.vl-tax-frete.*/
        otherwise return error.
    end case.
end procedure.
 
procedure getIntField:
    define input  parameter c-field as char.
    define output parameter c-value as integer.
 
    case c-field:
        when "cod-emitente" then c-value = RowObject.cod-emitente.
        when "cod-ibge" then c-value = RowObject.cod-ibge.
        when "cod-observa" then c-value = RowObject.cod-observa.
        when "cod-ret-irf" then c-value = RowObject.cod-ret-irf.
        &if defined(bf-mat-comex) &then
           when "nro-docto" then c-value = RowObject.nro-docto.        
           when "ct-transit" then c-value = RowObject.ct-transit.           
           when "sc-transit" then c-value = RowObject.sc-transit.           
        &else
           when "ind-orig-entrada" then c-value = RowObject.ind-orig-entrada.
           when "esp-docto" then c-value = RowObject.esp-docto.
           when "ind-via-envio" then c-value = RowObject.ind-via-envio.
           when "mo-codigo" then c-value = RowObject.mo-codigo.           
           when "nro-proc-entrada" then c-value = RowObject.nro-proc-entrada.
           when "mod-frete" then c-value = RowObject.mod-frete.
           when "nro-proc-saida" then c-value = RowObject.nro-proc-saida.
           when "rateia-frete" then c-value = RowObject.rateia-frete.
           when "sit-atual" then c-value = RowObject.sit-atual.
           when "sit-docum" then c-value = RowObject.sit-docum.
           when "sit-edi" then c-value = RowObject.sit-edi.
           when "tipo-docto" then c-value = RowObject.tipo-docto.
           when "tp-rat-fret" then c-value = RowObject.tp-rat-fret.
        &endif     

        when "dia-util-irf" then c-value = RowObject.dia-util-irf.
        
        when "estado" then c-value = RowObject.estado.
        when "i-sequencia" then c-value = RowObject.i-sequencia.
        
        
        when "int-1" then c-value = RowObject.int-1.
        when "int-2" then c-value = RowObject.int-2.
        
        when "mod-atual" then c-value = RowObject.mod-atual.
        
        
        
        when "ok-fornec" then c-value = RowObject.ok-fornec.
        
        /*when "tipo-nota" then c-value = RowObject.tipo-nota.*/
        
        when "via-transp" then c-value = RowObject.via-transp.
        otherwise return error.
    end case.
end procedure.
 
procedure getDateField:
    define input  parameter c-field as char.
    define output parameter c-value as date.
 
    case c-field:
    
        &if defined(bf-mat-comex) &then
        &else
           when "data-1" then c-value = RowObject.data-1.
           when "data-2" then c-value = RowObject.data-2.
        &endif
        
        when "dt-atualiza" then c-value = RowObject.dt-atualiza.
        when "dt-emissao" then c-value = RowObject.dt-emissao.
        when "dt-entr-merc" then c-value = RowObject.dt-entr-merc.
        when "dt-trans" then c-value = RowObject.dt-trans.
        when "dt-venc-icm" then c-value = RowObject.dt-venc-icm.
        when "dt-venc-ipi" then c-value = RowObject.dt-venc-ipi.
        when "dt-venc-iss" then c-value = RowObject.dt-venc-iss.
        when "ok-data" then c-value = RowObject.ok-data.
        otherwise return error.
    end case.
end procedure.
 
procedure getLogField:
    define input  parameter c-field as char.
    define output parameter c-value as logical.
 
    case c-field:
        &if defined(bf-mat-comex) &then
           when "mod-frete" then c-value = RowObject.mod-frete. 
           when "rateia-frete" then c-value = RowObject.rateia-frete.
           when "tipo-docto" then c-value = RowObject.tipo-docto.
        &else
           when "ind-rateio" then c-value = RowObject.ind-rateio.        
           when "ind-tipo-rateio" then c-value = RowObject.ind-tipo-rateio.
           when "nf-emitida-est" then c-value = RowObject.nf-emitida-est.
        &endif
        
        when "acresc-financ" then c-value = RowObject.acresc-financ.
        when "ap-atual" then c-value = RowObject.ap-atual.
        when "atual-ft" then c-value = RowObject.atual-ft.
        /*when "atualiza-cr" then c-value = RowObject.atualiza-cr.*/
        when "CE-atual" then c-value = RowObject.CE-atual.
        when "cr-atual" then c-value = RowObject.cr-atual.
        when "estorn-comis" then c-value = RowObject.estorn-comis.
        when "ind-extrac" then c-value = RowObject.ind-extrac.
        
        
        when "log-1" then c-value = RowObject.log-1.
        when "log-2" then c-value = RowObject.log-2.
        
        when "nff" then c-value = RowObject.nff.
        when "of-atual" then c-value = RowObject.of-atual.
        when "rec-fisico" then c-value = RowObject.rec-fisico.
        otherwise return error.
    end case.
end procedure.

PROCEDURE getUltimoDocumentoNotaComplementar:
    DEFINE INPUT  PARAMETER p-cod-estabel  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAMETER p-cdn-emitente AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-rw-docum-est AS ROWID     NO-UNDO.
    
    DEF VAR da-dt-aux AS DATE INIT 01/01/1900 NO-UNDO.
    
    FOR EACH docum-est NO-LOCK USE-INDEX emitente
       WHERE docum-est.cod-emitente = p-cdn-emitente 
         AND docum-est.cod-estabel  = p-cod-estabel
         AND CAN-FIND(FIRST natur-oper WHERE natur-oper.nat-operacao = docum-est.nat-operacao AND natur-oper.nota-rateio  = YES):
         
         IF  SUBSTRING(docum-est.char-1,1,20) <> "" 
         AND docum-est.dt-emissao             >  da-dt-aux THEN
            ASSIGN da-dt-aux      = docum-est.dt-emissao
                   p-rw-docum-est = ROWID(docum-est).
    END.
    
    RETURN "OK":U.
    
END PROCEDURE.
