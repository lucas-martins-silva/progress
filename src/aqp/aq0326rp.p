/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0326RP 2.00.00.008 } /*** "010008" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0326RP MAQ}
&ENDIF

/******************************************************************************
**
**       Programa: AQ0326RP.P.P
**
**       Data....: 20/12/2016.
**
**       Objetivo: Envio de XML da NF-e para o Transportador
**                 M¢dulo Aquisiá∆o de Produtos Rurais.
** 
******************************************************************************/
{utp/utapi019.i}
{utp/ut-glob.i}
{include/tt-edit.i}
{include/i-rpvar.i}

{aqp/aq0326.i} /* Definicao temp-tables */
    
/*********** TEMP-TABLES *****************/    
    
{cdp/cd0590.i} /*tt-comunica */


DEFINE TEMP-TABLE tt-erros-email NO-UNDO
    LIKE tt-erros
    FIELD email AS CHARACTER. 

DEFINE TEMP-TABLE tt-email
    FIELD cod-transp AS INTEGER
    FIELD nome       AS CHARACTER
    FIELD placa      AS CHARACTER
    FIELD email      AS CHARACTER
    FIELD anexo      AS CHARACTER
    FIELD periodo    AS CHARACTER
    FIELD remetente  AS CHARACTER.
    
DEFINE TEMP-TABLE tt-notas
    FIELD nr-nota-fis AS CHARACTER FORMAT "X(16)"
    FIELD serie       AS CHARACTER FORMAT "X(5)"
    FIELD cod-transp  AS INTEGER   FORMAT ">>,>>>9" 
    FIELD nome-transp AS CHARACTER FORMAT "X(40)"
    FIELD placa       AS CHARACTER FORMAT "X(9)"
    FIELD encontrado  AS LOGICAL.

/************************** VARIABLES ************************************/  
DEFINE VARIABLE c-titulo-notas-transp    AS CHARACTER FORMAT "X(19)":U NO-UNDO. 
DEFINE VARIABLE c-traco-notas-transp     AS CHARACTER FORMAT "X(19)":U NO-UNDO.
DEFINE VARIABLE c-lbl-cod-transp         AS CHARACTER FORMAT "X(13)":U NO-UNDO. 
DEFINE VARIABLE c-lbl-nome-transp        AS CHARACTER FORMAT "X(18)":U NO-UNDO. 
DEFINE VARIABLE c-lbl-placa              AS CHARACTER FORMAT "X(5)":U  NO-UNDO. 
DEFINE VARIABLE c-lbl-n-fiscal           AS CHARACTER FORMAT "X(9)":U  NO-UNDO. 
DEFINE VARIABLE c-lbl-serie              AS CHARACTER FORMAT "X(5)":U  NO-UNDO.
DEFINE VARIABLE c-lb-sel                 AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-regiao              AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-rota                AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-transp              AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-par                 AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-estabel             AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-period              AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-lb-item                AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-nome-estabel           AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-desc-item              AS CHARACTER                  NO-UNDO. 
DEFINE VARIABLE c-traco                  AS CHARACTER FORMAT "X(88)":U NO-UNDO.
DEFINE VARIABLE h-acomp                  AS HANDLE                     NO-UNDO.
DEFINE VARIABLE c-titulo-arquivos        AS CHARACTER FORMAT "X(28)":U NO-UNDO. 
DEFINE VARIABLE c-traco-arquivos         AS CHARACTER FORMAT "X(28)":U NO-UNDO.
DEFINE VARIABLE c-lbl-remetente          AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lbl-envia-email-transp AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lbl-envia-email-cc     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lbl-ender-email-cc     AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lbl-origem             AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lbl-destino            AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lb-dig                 AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lb-impr                AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lb-dest                AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lb-usuar               AS CHARACTER                  NO-UNDO.
DEFINE VARIABLE c-lb-erro-email          AS CHARACTER                  NO-UNDO. 


/************************** INITIlIZE HANDLES *******************************/  
IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    
/****************************** LABELS ***************************************/ 
{utp/ut-liter.i SELEÄ«O * r}
ASSIGN c-lb-sel             = TRIM(RETURN-VALUE).
{utp/ut-liter.i Regi∆o * r}
ASSIGN c-lb-regiao          = TRIM(RETURN-VALUE).
{utp/ut-liter.i Rota * r}
ASSIGN c-lb-rota            = TRIM(RETURN-VALUE).
{utp/ut-liter.i Transportador * r}
ASSIGN c-lb-transp          = TRIM(RETURN-VALUE).
{utp/ut-liter.i PAR∂METROS * r}
ASSIGN c-lb-par             = TRIM(RETURN-VALUE).
{utp/ut-liter.i Estabelecimento * r}
ASSIGN c-lb-estabel         = TRIM(RETURN-VALUE).
{utp/ut-liter.i Per°odo * r}
ASSIGN c-lb-period          = TRIM(RETURN-VALUE).
{utp/ut-liter.i Item * r}
ASSIGN c-lb-item            = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Notas Transportadas" * }
ASSIGN c-titulo-notas-transp = TRIM(RETURN-VALUE)
       c-traco-notas-transp  =  FILL("-",19).
{utp/ut-liter.i "Transportador" * }      
ASSIGN c-lbl-cod-transp      =  TRIM(RETURN-VALUE). 
{utp/ut-liter.i "Nome Transportador" * }      
ASSIGN c-lbl-nome-transp     =  TRIM(RETURN-VALUE).
{utp/ut-liter.i "Placa" * }      
ASSIGN c-lbl-placa           =  TRIM(RETURN-VALUE).
{utp/ut-liter.i "N. Fiscal" * }      
ASSIGN c-lbl-n-fiscal        =  TRIM(RETURN-VALUE).
{utp/ut-liter.i "SÇrie" * }      
ASSIGN c-lbl-serie           =  TRIM(RETURN-VALUE).
{utp/ut-liter.i "Arquivos XML n∆o encontrados" * }
ASSIGN c-titulo-arquivos     = TRIM(RETURN-VALUE)
       c-traco-arquivos      = FILL("-", 28).
{utp/ut-liter.i "Remetente" *}  
ASSIGN c-lbl-remetente       = RETURN-VALUE.
{utp/ut-liter.i "Envia e-mail para Transportador" *}  
ASSIGN c-lbl-envia-email-transp = RETURN-VALUE. 
{utp/ut-liter.i "Envia e-mail CC" *}  
ASSIGN c-lbl-envia-email-cc  = RETURN-VALUE. 
{utp/ut-liter.i "Endereáo e-mail CC" *}  
ASSIGN c-lbl-ender-email-cc  = RETURN-VALUE. 
{utp/ut-liter.i "Origem" *}  
ASSIGN c-lbl-origem          = RETURN-VALUE. 
{utp/ut-liter.i "Destino" *}  
ASSIGN c-lbl-destino         = RETURN-VALUE. 
{utp/ut-liter.i "DIGITAÄ«O" * r}
ASSIGN c-lb-dig              = TRIM(RETURN-VALUE).
{utp/ut-liter.i "IMPRESS«O" * r}
ASSIGN c-lb-impr             = TRIM(RETURN-VALUE).
{utp/ut-liter.i "Destino" * r}
ASSIGN c-lb-dest             = TRIM(RETURN-VALUE). 
{utp/ut-liter.i "Usu†rio" * r}
ASSIGN c-lb-usuar            = TRIM(RETURN-VALUE).
{utp/ut-liter.i "E-mail's com erro de envio" * }
ASSIGN c-lb-erro-email = RETURN-VALUE.

ASSIGN c-traco = FILL("-", 14) /* Transportador      */
         + " " + FILL("-", 40) /* Nome Transportador */ 
         + " " + FILL("-", 9)  /* Placa              */
         + " " + FILL("-", 16) /* N. Fiscal          */
         + " " + FILL("-", 5). /* Serie              */

/****************************** FORMS ***************************************/ 

FORM c-titulo-notas-transp  NO-LABEL FORMAT "X(19)":U SKIP
     c-traco-notas-transp   NO-LABEL FORMAT "X(19)":U SKIP(2)
     c-lbl-cod-transp       NO-LABEL FORMAT "X(13)":U AT 5
     c-lbl-nome-transp      NO-LABEL FORMAT "X(18)":U AT 20
     c-lbl-placa            NO-LABEL FORMAT "X(5)":U  AT 61
     c-lbl-n-fiscal         NO-LABEL FORMAT "X(9)":U  AT 71
     c-lbl-serie            NO-LABEL FORMAT "X(5)":U  AT 88  SKIP
     c-traco                NO-LABEL FORMAT "X(88)":U AT 5
     WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-tit-notas-transp. 

FORM tt-notas.cod-transp  NO-LABEL FORMAT ">>,>>>9"   AT 5
     tt-notas.nome-transp NO-LABEL FORMAT "X(40)":U   AT 20
     tt-notas.placa       NO-LABEL FORMAT "X(9)":U    AT 61
     tt-notas.nr-nota-fis NO-LABEL FORMAT "X(16)":U   AT 71
     tt-notas.serie       NO-LABEL FORMAT "X(5)":U    AT 88
     WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-notas.

FORM c-titulo-arquivos  NO-LABEL FORMAT "X(28)":U SKIP
     c-traco-arquivos   NO-LABEL FORMAT "X(28)":U SKIP(2)
     c-lbl-cod-transp   NO-LABEL FORMAT "X(13)":U AT 5
     c-lbl-nome-transp  NO-LABEL FORMAT "X(18)":U AT 20
     c-lbl-placa        NO-LABEL FORMAT "X(5)":U  AT 61
     c-lbl-n-fiscal     NO-LABEL FORMAT "X(9)":U  AT 71
     c-lbl-serie        NO-LABEL FORMAT "X(5)":U  AT 88  SKIP
     c-traco            NO-LABEL FORMAT "X(88)":U AT 5     
     WITH STREAM-IO SIDE-LABELS NO-ATTR-SPACE NO-BOX WIDTH 132 DOWN FRAME f-tit-arquivos. 

FORM tt-digita.cod-transp FORMAT ">>,>>>9" 
     tt-digita.descricao  FORMAT "X(40)"
     tt-digita.email      FORMAT "X(70)"
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-digita.
     
FORM tt-erros-email.email      FORMAT "X(50)" COLUMN-LABEL "E-mail" AT 5
     tt-erros-email.desc-erro  FORMAT "X(75)" COLUMN-LABEL "Erro"     
     WITH DOWN NO-BOX WIDTH 132 STREAM-IO FRAME f-erro-email.     


/*********************** TRANSLATION FORMS ********************************/ 
RUN utp/ut-trfrrp.p (INPUT FRAME f-tit-notas-transp:HANDLE).     
RUN utp/ut-trfrrp.p (INPUT FRAME f-notas:HANDLE).  
RUN utp/ut-trfrrp.p (INPUT FRAME f-tit-arquivos:HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-digita:HANDLE).
RUN utp/ut-trfrrp.p (INPUT FRAME f-erro-email:HANDLE).
    
/* ************************  Function Prototype ***************** */
FUNCTION fn-formata-diretorio RETURNS CHARACTER
  ( c-diretorio AS CHARACTER ) FORWARD.
  
FUNCTION fn-label-logico RETURNS CHARACTER
  ( pl-logical AS LOGICAL ) FORWARD.
  
FUNCTION removeAccents RETURNS CHAR
  ( str AS CHARACTER)  FORWARD.
  
/* PARAMETERS  */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param TO tt-param.

FOR EACH tt-raw-digita NO-LOCK:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.    

{include/i-rpcab.i}

{utp/ut-liter.i "Envio de XML para Transportador" * }
ASSIGN c-titulo-relat = RETURN-VALUE.

{utp/ut-liter.i "Aquisiá∆o de Produtos Rurais" MAQ}    
ASSIGN c-programa     = "AQ0326":U
       c-versao       = "I.00":U
       c-revisao      = "001":U
       c-sistema      = RETURN-VALUE
       c-rodape       = "TOTVS - " + c-programa  +  " - V:":U + c-versao.
       c-rodape       = FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.

IF VALID-HANDLE(h-acomp) THEN
    RUN pi-inicializar IN h-acomp (INPUT c-titulo-relat).           
       
FOR FIRST empresa FIELDS(razao-social) NO-LOCK 
    WHERE empresa.ep-codigo = i-ep-codigo-usuario:
    ASSIGN c-empresa  = empresa.razao-social.
END.

FIND FIRST tt-param NO-ERROR.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.

ASSIGN tt-param.destino-xml = fn-formata-diretorio(tt-param.destino-xml)
       tt-param.origem-xml  = fn-formata-diretorio(tt-param.origem-xml).

/* Busca arquivos XML no diretÛrio do Coloboracao e organiza por TRANSPORTADOR/PLACA */
RUN pi-busca-xml IN THIS-PROCEDURE.

/* Enviar e-mail com os arquivos xml para os transportadores existentes na tt-digita */
IF tt-param.envia-email-transp THEN 
    RUN pi-envia-email-transp IN THIS-PROCEDURE.    
   
{include/i-rpout.i}
VIEW FRAME f-cabec.
VIEW FRAME f-rodape.
 
RUN pi-gerar-log IN THIS-PROCEDURE.    
  
IF VALID-HANDLE(h-acomp) THEN  
    RUN pi-finalizar IN h-acomp.


PROCEDURE pi-busca-xml:

    DEFINE VARIABLE c-arq-xml-tc20  AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-arq-xml-docto AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VARIABLE c-arq-xml-chave AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE VARIABLE c-source        AS CHARACTER           NO-UNDO.
    DEFINE VARIABLE c-target        AS CHARACTER           NO-UNDO.

    {utp/ut-liter.i "Buscando Arquivos XML" * }
    IF VALID-HANDLE(h-acomp) THEN
        RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE).   
    
    FOR EACH tt-digita:
    
        FOR EACH nf-produt-propried FIELDS(nro-docto cod-estabel serie-docto cdn-produt-rural) NO-LOCK
           WHERE nf-produt-propried.it-codigo   = tt-param.it-codigo
             AND nf-produt-propried.cod-period  = tt-param.cod-periodo
             AND nf-produt-propried.cod-estabel = tt-param.cod-estabel
             AND nf-produt-propried.num-livre-1 = 0, /* desconsidera complementar */            
           FIRST nota-fiscal FIELDS(placa nr-nota-fis serie cod-chave-aces-nf-eletro cod-estabel) NO-LOCK
           WHERE nota-fiscal.nr-nota-fis = nf-produt-propried.nro-docto
             AND nota-fiscal.cod-estabel = nf-produt-propried.cod-estabel
             AND nota-fiscal.serie       = nf-produt-propried.serie-docto
             AND nota-fiscal.nome-transp = tt-digita.nome-abrev:
             
            FOR EACH propried-rural FIELDS() NO-LOCK
               WHERE propried-rural.cdn-produt-rural = nf-produt-propried.cdn-produt-rural 
                 AND propried-rural.cod-regiao      >= tt-param.cod-regiao-ini 
                 AND propried-rural.cod-regiao      <= tt-param.cod-regiao-fim
                 AND propried-rural.cod-rota-princ  >= tt-param.cod-rota-ini
                 AND propried-rural.cod-rota-princ  <= tt-param.cod-rota-fim:
                 
                /* INCREMENTA DIRETORIO DE ORIGEM COM O CODIGO DO TRANSPORTADOR */ 
                ASSIGN c-target = TRIM(tt-param.destino-xml) + TRIM(removeAccents(STRING(tt-digita.nome-abrev))) + "/". 
                
                OS-CREATE-DIR TO VALUE(c-target). /* Cria diretorio*/
                /* SE EXISTIR INFORMA«√O DA PLACA DO VEICULO DO TRANSPORTADOR NA NOTA FISCAL, CRIA SUB DIRETORIO POR PLACA */
                IF nota-fiscal.placa <> "" THEN DO:                    
                    ASSIGN c-target = c-target + TRIM(nota-fiscal.placa) + "/".
                    OS-CREATE-DIR TO VALUE(c-target). /* Cria diretorio*/
                END.
                
                CREATE tt-notas.
                ASSIGN tt-notas.nr-nota-fis  = nota-fiscal.nr-nota-fis
                       tt-notas.serie        = nota-fiscal.serie 
                       tt-notas.cod-transp   = tt-digita.cod-transp
                       tt-notas.nome-transp  = tt-digita.descricao 
                       tt-notas.placa        = nota-fiscal.placa.                        
                
                /* SE A INTEGRACAO FOR VIA TOTVS COLABORACAO 2.0 */
                IF tt-param.tipo-integr = "TC2":U OR tt-param.tipo-integr = "TPF":U THEN DO:
                    bloco_leitura:
                    FOR FIRST integr-totvs-colab FIELDS(cod-msg raw-contdo) NO-LOCK
                        WHERE integr-totvs-colab.cod-edi   = "170" 
                          AND integr-totvs-colab.cod-docto = nota-fiscal.cod-chave-aces-nf-eletro 
                          AND integr-totvs-colab.log-lido  = YES                            
                          AND integr-totvs-colab.cod-origem  = 2: 
                        EMPTY TEMP-TABLE tt-comunica.
                        {cdp/cd0590.i2 "tt-comunica" "integr-totvs-colab"}                             
                        IF tt-comunica.cStat = "100" THEN DO:
                            ASSIGN c-arq-xml-tc20 = TRIM(ENTRY(2, integr-totvs-colab.cod-msg, "|")) /* NOME DO ARQUIVO XML */
                                   c-source = tt-param.origem-xml + c-arq-xml-tc20 /* DIRETORIO + ARQUIVO ORIGEM */
                                   c-target = c-target + c-arq-xml-tc20. /* DIRETORIO + ARQUIVO DESTINO */
                            /* SE EXISTIR O ARQUIVO XML NO DIRETORIO, REALIZA A COPIA PARA O DIRETORIO DESTINO */
                            IF SEARCH(c-source) <> ? THEN DO:
                                OS-COPY VALUE(c-source) VALUE(c-target). 
                                ASSIGN tt-notas.encontrado = yes.
                            END.
                                                               
                        END.
                    END.
                END.
                ELSE DO: 
                
                    ASSIGN c-arq-xml-docto = TRIM(nota-fiscal.cod-estabel) +  /* Estabelecimento */
                                           SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,23,3) +  /* serie */
                           TRIM(STRING(INT(SUBSTR(nota-fiscal.cod-chave-aces-nf-eletro,26,9)),">>9999999":U)) + ".XML":U /*numero nota*/
                           
                           c-arq-xml-chave = TRIM(nota-fiscal.cod-chave-aces-nf-eletro) + ".XML":U. /* chave de acesso */
                           
                    ASSIGN c-source = TRIM(tt-param.origem-xml). /* Diretorio de Origem */
                    
                    /* ARQUIVO NOMEADO POR NUMERO DO DOCUMENTO */       
                    IF SEARCH(c-source + c-arq-xml-docto) <> ? THEN DO:
                        ASSIGN c-source = c-source + c-arq-xml-docto
                               c-target = c-target + c-arq-xml-docto
                               tt-notas.encontrado = YES.
                    END.           
                    ELSE DO:
                        /* ARQUIVO NOMEADO COM A CHAVE DE ACESSO */
                        IF SEARCH(c-source + c-arq-xml-chave) <> ? THEN
                            ASSIGN c-source = c-source + c-arq-xml-chave
                                   c-target = c-target + c-arq-xml-chave
                                   tt-notas.encontrado = YES.
                        ELSE
                            NEXT.
                    END.
                    
                    /* SE EXISTIR O ARQUIVO XML NO DIRETORIO, REALIZA A COPIA PARA O DIRETORIO DESTINO */                              
                    OS-COPY VALUE(c-source) VALUE(c-target).  
                    IF NOT CAN-FIND(FIRST tt-email 
                                    WHERE tt-email.cod-transp = tt-digita.cod-transp 
                                      AND tt-email.placa = nota-fiscal.placa) THEN DO:
                                      
                        CREATE tt-email.                    
                        ASSIGN tt-email.cod-transp = tt-digita.cod-transp
                               tt-email.nome       = tt-digita.descricao
                               tt-email.placa      = nota-fiscal.placa
                               tt-email.email      = tt-digita.email
                               tt-email.anexo      = c-target
                               tt-email.periodo    = tt-param.cod-periodo
                               tt-email.remetente  = tt-param.remetente.
                    END.
                    ELSE DO:
                        ASSIGN tt-email.anexo      = tt-email.anexo + "," + c-target.
                    END.
                END.
            END.
        END.  
    END.
    
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-envia-email-transp:
    DEFINE VARIABLE c-assunto-transp     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-descr-email-transp AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-assunto-placa      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-descr-email-placa  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-acomp              AS CHARACTER NO-UNDO.

    {utp/ut-liter.i "Arquivos XML das NFes dos produtos transportados pelo transportador &1" * }
    ASSIGN c-assunto-transp = RETURN-VALUE.
    {utp/ut-liter.i "Seguem anexos os arquivos XML das Notas Fiscais Eletrìnicas dos produtos transportados pelo transportador &1 no per°odo &2" *}
    ASSIGN c-descr-email-transp = RETURN-VALUE.

    {utp/ut-liter.i "Arquivos XML das NFes dos produtos transportados pelo ve°culo de placa &1" * }
    ASSIGN c-assunto-placa = RETURN-VALUE.
    {utp/ut-liter.i "Seguem anexos os arquivos XML das Notas Fiscais Eletrìnicas dos produtos transportados pelo ve°culo de placa &1 no per°odo &2" *}
    ASSIGN c-descr-email-placa = RETURN-VALUE.
    
    {utp/ut-liter.i "Enviando Email para &1" * }
    ASSIGN c-acomp = RETURN-VALUE.
    
    IF NOT VALID-HANDLE(h-utapi019) THEN
        RUN utp/utapi019.p PERSISTENT SET h-utapi019 NO-ERROR.
        
    FIND FIRST param_email NO-LOCK NO-ERROR.
    IF NOT AVAIL param_email THEN RETURN "NOK":U.
    
    blk_email:
    FOR EACH tt-email
          BY tt-email.cod-transp:
        
        EMPTY TEMP-TABLE tt-erros    NO-ERROR.
        EMPTY TEMP-TABLE tt-envio2   NO-ERROR.
        EMPTY TEMP-TABLE tt-mensagem NO-ERROR.
        
        IF VALID-HANDLE(h-acomp) THEN
            RUN pi-acompanhar IN h-acomp (INPUT REPLACE(c-acomp,"&1",tt-email.email)).
        
        CREATE tt-envio2.
        ASSIGN tt-envio2.versao-integracao = 1
               tt-envio2.remetente         = tt-email.remetente
               tt-envio2.importancia       = 1
               tt-envio2.destino           = tt-email.email
               tt-envio2.log-enviada       = NO
               tt-envio2.exchange          = param_email.log_servid_exchange 
               tt-envio2.log-lida          = NO
               tt-envio2.servidor          = param_email.cod_servid_e_mail
               tt-envio2.porta             = param_email.num_porta
               tt-envio2.arq-anexo         = tt-email.anexo
               tt-envio2.acomp             = NO NO-ERROR.
               
        IF tt-param.envia-email-cc THEN
            ASSIGN tt-envio2.copia = tt-param.email-cc.
                   
        IF tt-email.placa = "" THEN
            ASSIGN tt-envio2.assunto  = REPLACE(c-assunto-transp, "&1", tt-email.nome)
                   tt-envio2.mensagem = REPLACE(c-descr-email-transp, "&1", tt-email.nome)
                   tt-envio2.mensagem = REPLACE(tt-envio2.mensagem, "&2", SUBSTRING(tt-email.periodo, 1, 2) + "/" +  SUBSTRING(tt-email.periodo, 3, 4)).
        ELSE 
            ASSIGN tt-envio2.assunto  = REPLACE(c-assunto-placa, "&1", tt-email.placa)
                   tt-envio2.mensagem = REPLACE(c-descr-email-placa, "&1", tt-email.placa)
                   tt-envio2.mensagem = REPLACE(tt-envio2.mensagem, "&2", SUBSTRING(tt-email.periodo, 1, 2) + "/" +  SUBSTRING(tt-email.periodo, 3, 4)).                        
                   
                   
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.mensagem = tt-envio2.mensagem NO-ERROR.
          
         
        RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,
                                       INPUT  TABLE tt-mensagem,
                                       OUTPUT TABLE tt-erros) NO-ERROR.
                                           
        FOR EACH TT-ERROS:
            IF NOT CAN-FIND(FIRST tt-erros-email 
                            WHERE tt-erros-email.email = tt-email.email) THEN DO:
        
                CREATE tt-erros-email.
                BUFFER-COPY tt-erros TO tt-erros-email.
                ASSIGN tt-erros-email.email = tt-email.email.
            END.      
        END.

    END.
    
    DELETE PROCEDURE h-utapi019.
    ASSIGN h-utapi019 = ?.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-gerar-log:

    DEFINE VARIABLE l-encontrou-nota AS LOGICAL NO-UNDO.

    IF CAN-FIND(FIRST tt-notas
                WHERE tt-notas.encontrado) THEN DO:
        
        ASSIGN l-encontrou-nota = TRUE.

        DISPLAY c-titulo-notas-transp
                c-traco-notas-transp 
                c-lbl-cod-transp
                c-lbl-nome-transp
                c-lbl-placa
                c-lbl-n-fiscal
                c-lbl-serie 
                c-traco
                WITH DOWN FRAME f-tit-notas-transp.
        DOWN WITH FRAME f-tit-notas-transp.
        
        
        FOR EACH tt-notas
           WHERE tt-notas.encontrado:
            DISPLAY tt-notas.cod-transp 
                    tt-notas.nome-transp
                    tt-notas.placa
                    tt-notas.nr-nota-fis
                    tt-notas.serie 
                    WITH DOWN FRAME f-notas.
            DOWN WITH FRAME f-notas.
        END.       
    END.
    
    IF CAN-FIND(FIRST tt-notas
                WHERE NOT tt-notas.encontrado) THEN DO:
        
        /* SE INPRIMIU ALGUMA NOTA, REALIZA A QUEBRA DE LINHAS */
        IF l-encontrou-nota THEN
             DISPLAY SKIP(2).
                
        DISPLAY c-titulo-arquivos
                c-traco-arquivos
                c-lbl-cod-transp
                c-lbl-nome-transp
                c-lbl-placa
                c-lbl-n-fiscal
                c-lbl-serie 
                c-traco
                WITH DOWN FRAME f-tit-arquivos.
        DOWN WITH FRAME f-tit-arquivos.
        
        FOR EACH tt-notas
           WHERE NOT tt-notas.encontrado:
        
            DISPLAY tt-notas.cod-transp 
                    tt-notas.nome-transp                       
                    tt-notas.placa
                    tt-notas.nr-nota-fis
                    tt-notas.serie 
                    WITH DOWN FRAME f-notas.
            DOWN WITH FRAME f-notas.
        END.
    END.   
    
    IF CAN-FIND(FIRST tt-erros-email) THEN DO:
        PUT UNFORMATTED SKIP(3)
            c-lb-erro-email SKIP
            FILL("-", 26)   SKIP(1).
        /*digitaÁ„o*/
        FOR EACH tt-erros-email:
            DISP tt-erros-email.email 
                 tt-erros-email.desc-erro 
                     WITH FRAME f-erro-email.
                DOWN WITH FRAME f-erro-email.
        
        END.
    END.
    

    /* IMPRESS√O PARAMETROS */
    IF tt-param.imp-param THEN
        RUN pi-imprime-parametros IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.


PROCEDURE pi-imprime-parametros:
    /*seleÁ„o*/
    PUT UNFORMATTED SKIP(3)
        c-lb-sel     SKIP
        FILL("-",7)  SKIP        
        c-lb-regiao  AT 5  ": " tt-param.cod-regiao-ini AT 20 "|<  >| " AT 33 tt-param.cod-regiao-fim
        c-lb-rota    AT 5  ": " tt-param.cod-rota-ini   AT 20 "|<  >| " AT 33 tt-param.cod-rota-fim
        c-lb-transp  AT 5  ": " tt-param.cod-transp-ini AT 20 "|<  >| " AT 33 tt-param.cod-transp-fim.    
   
    /*parÉmetros*/
    PUT UNFORMATTED SKIP(1)
        c-lb-par                 SKIP
        FILL("-",9)              SKIP
        c-lb-estabel             AT 5  ": " + tt-param.cod-estabel + " - " + tt-param.nome-estabel                    AT 36
        c-lb-period              AT 5  ": " + SUBSTR(tt-param.cod-period,1,2) + "/" + SUBSTR(tt-param.cod-period,3,4) AT 36
        c-lb-item                AT 5  ": " + tt-param.it-codigo + " - " +  tt-param.desc-item                        AT 36
        c-lbl-remetente          AT 5  ": " + tt-param.remetente                                                      AT 36
        c-lbl-envia-email-transp AT 5  ": " + fn-label-logico(tt-param.envia-email-transp)                            AT 36
        c-lbl-envia-email-cc     AT 5  ": " + fn-label-logico(tt-param.envia-email-cc )                               AT 36
        c-lbl-ender-email-cc     AT 5  ": " + tt-param.email-cc                                                       AT 36
        c-lbl-origem             AT 5  ": " + tt-param.origem-xml                                                     AT 36
        c-lbl-destino            AT 5  ": " + tt-param.destino-xml                                                    AT 36.
    
    /*digitaá∆o*/
    IF CAN-FIND(FIRST tt-digita) THEN DO:
        PUT UNFORMATTED SKIP(1)
            c-lb-dig               SKIP
            FILL("-",8)            SKIP.
        /*digitaÁ„o*/
        FOR EACH tt-digita:
            DISP tt-digita.cod-transp AT 5
                 tt-digita.descricao
                 tt-digita.email
                     WITH FRAME f-digita.
                DOWN WITH FRAME f-digita.
        
        END.
        /***********/
    END.  
    /*impress„o*/
    PUT UNFORMATTED SKIP(1)
        c-lb-impr               SKIP
        FILL("-",9)             SKIP(1)
        c-lb-dest               AT 5  ": " tt-param.destino " - " tt-param.arquivo
        c-lb-usuar              AT 5  ": " tt-param.usuario SKIP(1).
        
    RETURN "OK":U.
END PROCEDURE.


{include/pi-edit.i}

  
{include/i-rpclo.i} /* Include padrao de relatorio */

RETURN "OK".


/* ************************  Function Implementations ***************** */
FUNCTION fn-formata-diretorio RETURNS CHARACTER
  ( c-diretorio AS CHARACTER ) :
  
    IF SUBSTRING(c-diretorio, LENGTH(c-diretorio),1) <> "/":U  THEN
        ASSIGN c-diretorio = c-diretorio + "/":U. 
  
    RETURN c-diretorio.   /* Function return value. */
END FUNCTION.

FUNCTION fn-label-logico  RETURNS CHARACTER
 ( pl-logical AS LOGICAL ) :
 
    IF  pl-logical THEN DO:
        {utp/ut-liter.i "Sim" *}
    END.
    ELSE DO:
        {utp/ut-liter.i "N∆o" *}
    END.
    
    RETURN RETURN-VALUE.   /* Function return value. */
END FUNCTION.

FUNCTION fn-label-logico RETURNS CHARACTER
  ( pl-logical AS LOGICAL ) FORWARD.  
  
FUNCTION removeAccents RETURNS CHAR
  ( str AS CHARACTER) :
/*------------------------------------------------------------------------------
    Purpose:  
              
    Notes:  
------------------------------------------------------------------------------*/
    ASSIGN str = replace(str, "∆", "a") /* atilde */
           str = replace(str, "†", "a") /* aacute */
           str = replace(str, "É", "a") /* acirc */
           str = replace(str, "Ç", "e") /* eacute */
           str = replace(str, "£", "u") /* uacute */
           str = replace(str, "°", "i") /* iacute */
           str = replace(str, "à", "e") /* ecirc */
           str = replace(str, "á", "c") /* ccedil */
           str = replace(str, "‰", "o") /* otilde */
           str = replace(str, "¢", "o") /* oacute */
           str = replace(str, "Ö", "a") /* acrase */
           str = replace(str, "«", "A") /* Atilde */
           str = replace(str, "µ", "A") /* Aacute */
           str = replace(str, "ê", "E") /* Eacute */
           str = replace(str, "È", "U") /* Uacute */
           str = replace(str, "÷", "I") /* Iacute */
           str = replace(str, "“", "E") /* Ecirc */
           str = replace(str, "∂", "A") /* Acirc */
           str = replace(str, "Ä", "C") /* Ccedil */
           str = replace(str, "Â", "O") /* Otilde */
           str = replace(str, "‡", "O") /* Oacute */
           str = replace(str, "∑", "A") /* Acrase */          
           str = replace(str, "„", "a") /* atilde */
           str = replace(str, "·", "a") /* aacute */
           str = replace(str, "È", "e") /* eacute */
           str = replace(str, "Í", "e") /* ecirc */
           str = replace(str, "‚", "a") /* acirc */
           str = replace(str, "Á", "c") /* ccedil */
           str = replace(str, "ı", "o") /* otilde */
           str = replace(str, "Û", "o") /* oacute */
           str = replace(str, "Ì", "i") /* iacute */
           str = replace(str, "˙", "u") /* uacute */
           str = replace(str, "‡", "a") /* acrase */
           str = replace(str, "√", "A") /* Atilde */
           str = replace(str, "¡", "A") /* Aacute */
           str = replace(str, "…", "E") /* Eacute */
           str = replace(str, "⁄", "U") /* Uacute */
           str = replace(str, "Õ", "I") /* Iacute */
           str = replace(str, " ", "E") /* Ecirc */
           str = replace(str, "¬", "A") /* Acirc */
           str = replace(str, "’", "O") /* Otilde */
           str = replace(str, "”", "O") /* Oacute */
           str = replace(str, "¿", "A"). /* Acrase */

   RETURN str.
END FUNCTION.






