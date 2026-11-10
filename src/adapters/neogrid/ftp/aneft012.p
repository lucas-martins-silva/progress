/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i ANEFT012 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i aneft012 MAN}
&ENDIF

/******************************************************************************
**  Programa: ANEFT012.p
**  Funcao  : Sender de Unidades de Federa‡Æo
**  Data    : 05/2003
**  Autor   : Liziane Leite
******************************************************************************/

/* Todos os programas que forem exclusivos do projeto NeoGrid (b2b), somente
   rodarao em clientes com versao do Progress igual ou superior a 8. E' um
   pre-requisito para instalar o sistema.
   O programa abaixo foi digitado no editor da 9, por isso apresenta as
   quebras de linha. */

{utp/ut-glob.i}
{cdp/cdcfgdis.i}

DEFINE INPUT  PARAMETER r-unid-feder AS ROWID      NO-UNDO.

DEFINE VARIABLE c-root                           AS CHAR NO-UNDO. 
DEFINE VARIABLE c-message                        AS CHAR NO-UNDO.
DEFINE VARIABLE c-colecao-unidade-federacao      AS CHAR NO-UNDO.

DEFINE VARIABLE c-campo                          AS CHAR NO-UNDO.
DEFINE VARIABLE c-FromRole                       AS CHAR NO-UNDO.
DEFINE VARIABLE c-ToRole                         AS CHAR NO-UNDO.


{adapters/neogrid/include/anein004.i} /*sender*/

RUN pi-cabecalho-msg.

IF  r-unid-feder <> ? THEN
    FIND unid-feder WHERE ROWID(unid-feder) = r-unid-feder NO-LOCK NO-ERROR.
    IF  AVAIL unid-feder THEN
        RUN pi-corpo-msg.
    
RUN pi-rodape-msg.
WRITExml().

PROCEDURE pi-cabecalho-msg:
    ASSIGN c-root = CreateNeoGridDoc("UnidadeFederacao","1.01.001","1")
             c-message = AddElement(c-root,"Message")
               c-colecao-unidade-federacao = AddElement(c-message,"colecao-unidade-federacao")
               c-FromRole                  = AddElement(c-message,"FromRole")
               c-ToRole                    = AddElement(c-message,"ToRole").
END PROCEDURE.

PROCEDURE pi-corpo-msg:

    DEFINE VARIABLE c-unidade-federacao              AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-colecao-estado-excecao         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-estado-excecao                 AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-colecao-item-unidade-federacao AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-item-unidade-federacao         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-colecao-item-icms-difer-estado AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE c-item-icms-difer-estado         AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE i-cont                           AS INTEGER            NO-UNDO.
    DEFINE VARIABLE l-existe-excecao                 AS LOGICAL INITIAL NO NO-UNDO.

    ASSIGN c-unidade-federacao = AddElement(c-colecao-unidade-federacao,"unidade-federacao")
           c-campo = AddEleChar(c-unidade-federacao,"pais",unid-feder.pais)
           c-campo = AddEleChar(c-unidade-federacao,"estado",unid-feder.estado)
           c-campo = AddEleChar(c-unidade-federacao,"no-estado",unid-feder.no-estado)
           c-campo = AddEleInt(c-unidade-federacao,"moeda-corr-base-icms",unid-feder.int-2)
           c-campo = AddEleInt(c-unidade-federacao,"codigo-sinief",unid-feder.cod-sinief)
           c-campo = AddEleChar(c-unidade-federacao,"nr-tab-pauta",unid-feder.nr-tb-pauta)
           c-campo = AddEleChar(c-unidade-federacao,"possui-subst-trib",IF unid-feder.ind-uf-subs THEN "Sim" ELSE "NÆo")
           c-campo = AddEleChar(c-unidade-federacao,"possui-st-tabela-pauta",IF unid-feder.possui-subst-trib THEN "Sim" ELSE "NÆo")
           c-campo = AddEleChar(c-unidade-federacao,"ind-base-st",IF unid-feder.ind-base-st = 2 THEN "L¡quido" ELSE "Bruto")
           c-campo = AddEleDeci(c-unidade-federacao,"desc-icms",unid-feder.desc-icms)
           c-campo = AddEleDeci(c-unidade-federacao,"per-icms-int",unid-feder.per-icms-int)
           c-campo = AddEleDeci(c-unidade-federacao,"per-icms-ext",unid-feder.per-icms-ext)
           c-campo = AddEleDeci(c-unidade-federacao,"pc-icms-st",unid-feder.pc-icms-st)
           c-campo = AddEleDeci(c-unidade-federacao,"per-sub-tri",unid-feder.per-sub-tri).

    /* Cole‡Æo de Estados Exce‡äes */
    DO i-cont = 1 TO 12: /* Apesar do campo ser extent de 25, na tela de cadastro de exce‡äes, existem apenas 12 posi‡äes */
        IF  unid-feder.est-exc[i-cont] <> "" THEN DO:
            ASSIGN l-existe-excecao = YES.
            LEAVE.
        END.
    END.
    IF l-existe-excecao THEN DO:
        ASSIGN c-colecao-estado-excecao = AddElement(c-unidade-federacao,"colecao-estado-excecao").
               
        DO  i-cont = 1 TO 12:
            IF  unid-feder.est-exc[i-cont] <> "" THEN
                ASSIGN c-estado-excecao = AddElement(c-colecao-estado-excecao,"estado-excecao")
                         c-campo        = AddEleChar(c-estado-excecao,"est-exc",unid-feder.est-exc[i-cont])
                         c-campo        = AddEleDeci(c-estado-excecao,"perc-exc",unid-feder.perc-exc[i-cont])
                         c-campo        = AddEleDeci(c-estado-excecao,"perc-desc-icms",unid-feder.perc-exc[i-cont + 13]).
        END.
    END.

    /* Cole‡Æo item-uf */
    IF CAN-FIND(FIRST item-uf WHERE item-uf.pais            = unid-feder.pais 
                                AND item-uf.estado          = unid-feder.estado) THEN DO:

        ASSIGN c-colecao-item-unidade-federacao = AddElement(c-unidade-federacao,"colecao-item-unidade-federacao").

        FOR EACH item-uf 
           WHERE item-uf.pais            = unid-feder.pais
             AND item-uf.estado          = unid-feder.estado NO-LOCK:

            ASSIGN c-item-unidade-federacao   = AddElement(c-colecao-item-unidade-federacao,"item-unidade-federacao")
                     c-campo                  = AddEleChar(c-item-unidade-federacao,"it-codigo",item-uf.it-codigo)
                     c-campo                  = AddEleChar(c-item-unidade-federacao,"uf-origem",item-uf.cod-estado-orig)
                     c-campo                  = AddEleDeci(c-item-unidade-federacao,"per-sub-tri",item-uf.per-sub-tri)
                     c-campo                  = AddEleDeci(c-item-unidade-federacao,"perc-red-sub",item-uf.perc-red-sub)
                     c-campo                  = AddEleDeci(c-item-unidade-federacao,"icms-estadual-subs-trib",item-uf.dec-1)
                     &IF '{&bf_dis_versao_ems}' >= '2.08' &THEN
                         c-campo                  = AddEleDeci(c-item-unidade-federacao,"val-perc-reduc-tab-pauta",item-uf.val-perc-reduc-tab-pauta)
                     &ELSE
                         c-campo                  = AddEleDeci(c-item-unidade-federacao,"val-perc-reduc-tab-pauta",dec(substring(item-uf.char-1,1,8)))
			 
                     &ENDIF
                     .

        END.
    END.

    /* Cole‡Æo icms-it-uf */
    IF unid-feder.pais = "Brasil":U THEN
        IF  CAN-FIND(FIRST icms-it-uf WHERE icms-it-uf.estado = unid-feder.estado) THEN DO:
    
            ASSIGN c-colecao-item-icms-difer-estado = AddElement(c-unidade-federacao,"colecao-item-icms-difer-estado").
    
            FOR EACH icms-it-uf FIELDS(it-codigo aliquota-icm)
               WHERE icms-it-uf.estado = unid-feder.estado NO-LOCK:
    
                ASSIGN c-item-icms-difer-estado = AddElement(c-colecao-item-icms-difer-estado,"item-icms-difer-estado")
                         c-campo                = AddEleChar(c-item-icms-difer-estado,"it-codigo",icms-it-uf.it-codigo)
                         c-campo                = AddEleDeci(c-item-icms-difer-estado,"aliquota-icm",icms-it-uf.aliquota-icm).
            END.
        END.

END PROCEDURE.

PROCEDURE pi-rodape-msg:

    DEFINE VARIABLE c-Address AS CHARACTER  NO-UNDO.

    ASSIGN c-campo = AddEleChar(c-FromRole,"LegacyLocationIdentifier","")
             c-campo = AddEleChar(c-FromRole,"GlobalPartnerRoleClassificationCode","SELLER").

    FOR FIRST empresa FIELDS (endereco endereco-2 cidade bairro uf pais cep)
        WHERE empresa.ep-codigo = i-ep-codigo-usuario NO-LOCK:
    END.

    ASSIGN c-Address = AddElement(c-FromRole,"Address")
             c-campo = AddEleChar(c-Address,"AddressLine1",IF AVAIL empresa THEN empresa.endereco ELSE "")
             c-campo = AddEleChar(c-Address,"AddressLine2",IF AVAIL empresa THEN empresa.endereco-2 ELSE "")
             c-campo = AddEleChar(c-Address,"CityName",IF AVAIL empresa THEN empresa.cidade ELSE "")
             c-campo = AddEleChar(c-Address,"DistrictName",IF AVAIL empresa THEN empresa.bairro ELSE "")
             c-campo = AddEleChar(c-Address,"StateCode",IF AVAIL empresa THEN empresa.uf ELSE "")
             c-campo = AddEleChar(c-Address,"LegacyCountryCode",IF AVAIL empresa THEN empresa.pais ELSE "")
             c-campo = AddEleChar(c-Address,"NationalPostalCode",IF AVAIL empresa THEN empresa.cep ELSE "").
             
    ASSIGN c-campo = AddEleChar(c-ToRole,"LegacyLocationIdentifier","")
           c-campo = AddEleChar(c-ToRole,"GlobalPartnerRoleClassificationCode","").

    ASSIGN c-Address = AddElement(c-ToRole,"Address")
           c-campo = AddEleChar(c-Address,"AddressLine1","")
           c-campo = AddEleChar(c-Address,"AddressLine2","")
           c-campo = AddEleChar(c-Address,"CityName","")
           c-campo = AddEleChar(c-Address,"DistrictName","")
           c-campo = AddEleChar(c-Address,"StateCode","")
           c-campo = AddEleChar(c-Address,"LegacyCountryCode","")
           c-campo = AddEleChar(c-Address,"NationalPostalCode","").

END PROCEDURE.

