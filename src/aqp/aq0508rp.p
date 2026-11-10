/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0508RP 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i AQ0508RP MAQ}
&ENDIF

/******************************************************************************
**
**  Programa: AQ0508RP
**
**  Data....: MAIO de 2016
**
**  Objetivo: Relat¢rio Informa‡äes para Minist‚rio Agricultura
**
**  Versao..: 
**         
******************************************************************************/
DEFINE VARIABLE h-acomp                 AS HANDLE              NO-UNDO.
DEFINE VARIABLE h-utapi033              AS HANDLE              NO-UNDO.
DEFINE VARIABLE dt-dat-trans-ini        AS DATE                NO-UNDO.
DEFINE VARIABLE dt-dat-trans-fim        AS DATE                NO-UNDO.
DEFINE VARIABLE c-tit-coluna            AS CHARACTER EXTENT 15 NO-UNDO.
DEFINE VARIABLE c-period                AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-txt-fora-padrao       AS CHARACTER           NO-UNDO.
DEFINE VARIABLE i-num-col-dinamica      AS INTEGER   INIT 15   NO-UNDO.
DEFINE VARIABLE i-coluna                AS INT                 NO-UNDO.   
DEFINE VARIABLE c-todas-col-dinamic     AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-col-dinamicas-criadas AS CHARACTER           NO-UNDO.
DEFINE VARIABLE ch                      AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-descricao             AS CHARACTER           NO-UNDO.
DEFINE VARIABLE i-aux                   AS INTEGER             NO-UNDO.
DEFINE VARIABLE l-avail                 AS LOGICAL             NO-UNDO.
DEFINE VARIABLE d-resultado-min         AS DECIMAL             NO-UNDO.
DEFINE VARIABLE d-resultado-max         AS DECIMAL             NO-UNDO.
DEFINE VARIABLE c-acomp                 AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-lbl-pto-coleta        AS CHARACTER           NO-UNDO.
DEFINE VARIABLE c-lbl-produtor          AS CHARACTER           NO-UNDO.
DEFINE VARIABLE iParamColumnWidth AS INTEGER EXTENT 2   NO-UNDO.
DEFINE VARIABLE c-lbl-ate AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-nome-estabel AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-desc-item    AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-exame        AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-componente   AS CHARACTER NO-UNDO.
 
{utp/ut-liter.i "Estab" * }
ASSIGN c-tit-coluna[1] = RETURN-VALUE.

{utp/ut-liter.i "Per¡odo" * }
ASSIGN c-tit-coluna[2] = RETURN-VALUE.
 
{utp/ut-liter.i "C¢d Produtor" * }
ASSIGN c-tit-coluna[3] = RETURN-VALUE.

{utp/ut-liter.i "Nome Produtor" * }
ASSIGN c-tit-coluna[4] = RETURN-VALUE.

{utp/ut-liter.i "Pto Coleta" * }
ASSIGN c-tit-coluna[5] = RETURN-VALUE.

{utp/ut-liter.i "Desc Pto Coleta" * }
ASSIGN c-tit-coluna[6] = RETURN-VALUE.

{utp/ut-liter.i "Coletivo" * }
ASSIGN c-tit-coluna[7] = RETURN-VALUE + "?":U.

{utp/ut-liter.i "Reposit" * }
ASSIGN c-tit-coluna[8] = RETURN-VALUE.

{utp/ut-liter.i "Num Prod Reposit" * }
ASSIGN c-tit-coluna[9] = RETURN-VALUE.

{utp/ut-liter.i "Capacidade" * }
ASSIGN c-tit-coluna[10] = RETURN-VALUE + "(L)":U.

{utp/ut-liter.i "Volume Total" * }
ASSIGN c-tit-coluna[11] = RETURN-VALUE.

{utp/ut-liter.i "M‚dia Recep. Di ria" * }
ASSIGN c-tit-coluna[12] = RETURN-VALUE.

{utp/ut-liter.i "Latitude" * }
ASSIGN c-tit-coluna[13] = RETURN-VALUE.

{utp/ut-liter.i "Longitude" * }
ASSIGN c-tit-coluna[14] = RETURN-VALUE.

{utp/ut-liter.i "Amostras NÆo Coletadas" * }
ASSIGN c-tit-coluna[15] = RETURN-VALUE.
 
{utp/ut-liter.i "Fora PadrÆo" * }
ASSIGN c-txt-fora-padrao = RETURN-VALUE. 

/* Parameters Definitions ---                                           */

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino              AS INTEGER
    FIELD arquivo              AS CHAR format "x(35)":U
    FIELD usuario              AS CHAR format "x(12)":U
    FIELD data-exec            AS DATE
    FIELD hora-exec            AS INTEGER
    FIELD cod-rota-ini         AS CHARACTER
    FIELD cod-rota-fim         AS CHARACTER
    FIELD cdn-grp-produt-ini   AS INTEGER 
    FIELD cdn-grp-produt-fim   AS INTEGER 
    FIELD cdn-produt-rural-ini AS INTEGER 
    FIELD cdn-produt-rural-fim AS INTEGER 
    FIELD cod-pto-coleta-ini   AS CHARACTER
    FIELD cod-pto-coleta-fim   AS CHARACTER
    FIELD cod-estabel          AS CHARACTER
    FIELD period               AS CHARACTER FORMAT "99/9999"
    FIELD it-codigo            AS CHARACTER
    FIELD l-imp-param          AS LOGICAL
    FIELD l-inativos           AS LOGICAL.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD id         AS INTEGER 
    FIELD cod-exame  AS INTEGER  
    FIELD desc-exame AS CHARACTER
    FIELD cod-comp   AS INTEGER  
    FIELD desc-comp  AS CHARACTER.

DEFINE TEMP-TABLE tt-raw-digita
    FIELD raw-digita AS RAW.    
    
DEFINE TEMP-TABLE tt-ponto-coleta
    FIELD cod-estabel        LIKE carg-rural.cod-estabel
    FIELD cod-period         LIKE param-aquis-rural.cod-period   
    FIELD cdn-produt-respons LIKE produt-carg.cdn-produt-respons
    FIELD nome-produt        LIKE emitente.nome-emit    
    FIELD cod-pto-coleta     LIKE produt-carg.cod-pto-coleta
    FIELD des-pto-coleta     LIKE pto-coleta.des-pto-coleta
    FIELD pto-coletivo       AS CHARACTER    
    FIELD cdn-repos          LIKE produt-carg.cdn-repos
    FIELD num-produtores     AS INT
    FIELD qtd-capac-repos    LIKE reposit.qtd-capac     
    FIELD volume             LIKE produt-carg.qtd-coleta
    FIELD media-recep-dia    LIKE produt-carg.qtd-coleta
    FIELD val-lat-pto-coleta LIKE pto-coleta.val-latitude
    FIELD val-lon-pto-coleta LIKE pto-coleta.val-longitude    
    FIELD num-entregas         AS INT
    FIELD amostra-nao-coletada AS CHAR FORMAT "X(1)"
    FIELD dat-ult-trans        AS DATE.

/* Produtores que entregam no ponto de coleta */
DEFINE TEMP-TABLE tt-pto-coleta-produt
    FIELD cdn-identif        AS INT
    FIELD cod-pto-coleta     AS CHAR
    FIELD cdn-produt-rural   AS INT
    FIELD cdn-produt-respons AS INT
    FIELD cdn-repos          AS INT.  
    
/* resultados das analises */    
DEFINE TEMP-TABLE tt-resultado
    FIELD cod-pto-coleta AS CHARACTER
    FIELD cod-exame      AS INTEGER
    FIELD cod-comp       AS INTEGER
    FIELD valor          AS DECIMAL
    FIELD cont           AS INTEGER
    FIELD coluna         AS INTEGER.
    
DEFINE TEMP-TABLE tt-param-planilha NO-UNDO
    FIELD descricao AS CHARACTER
    FIELD valor     AS CHARACTER.    
    
    
    
    

/* ************************  Function Prototype ***************** */
FUNCTION fn-nome-produt RETURNS CHARACTER
  ( pi-cdn-produt-rural AS INT )  FORWARD.
  
  
FUNCTION fn-coletivo RETURNS CHARACTER
  ( p-log-pto-coleta-coletiv AS LOGICAL ) FORWARD.

{utp/ut-glob.i}
{method/dbotterr.i}

/* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita.

CREATE tt-param.
RAW-TRANSFER raw-param to tt-param.

FOR EACH tt-raw-digita:
    CREATE tt-digita.
    RAW-TRANSFER tt-raw-digita.raw-digita TO tt-digita.
END.

/* INSTANCIA HANDLES */
IF NOT VALID-HANDLE(h-utapi033) THEN
    RUN utp/utapi033.p PERSISTENT SET h-utapi033.

IF NOT VALID-HANDLE(h-acomp) THEN
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

{include/i-rpvar.i}
/*
{utp/ut-liter.i ImpressÆo_: *}
assign c-titulo-p = return-value.                       
{utp/ut-liter.i Destino *}
assign c-destino:label in frame f-impressao = return-value.
{utp/ut-liter.i Usu rio *}
assign tt-param.usuario:label in frame f-impressao = return-value.          
*/

FIND FIRST param-global NO-LOCK NO-ERROR.
IF AVAIL param-global THEN DO:
    FIND FIRST empresa WHERE empresa.ep-codigo = param-global.empresa-prin NO-LOCK NO-ERROR. 
    IF AVAIL empresa THEN 
        ASSIGN c-empresa = empresa.nome.
    ELSE 
        ASSIGN c-empresa  = param-global.grupo.
END.
    
{utp/ut-liter.i "Informa‡äes para Minist‚rio Agricultura" MAQ}
ASSIGN c-titulo-relat = c-empresa + FILL(" ", 20) + RETURN-VALUE + FILL(" ", 20) + STRING(TODAY) .

{utp/ut-liter.i AQUISI€åES_RURAIS maq}  
ASSIGN c-programa     = "AQ0311"
       c-versao       = "I.00"
       c-revisao      = "001"
       c-sistema      = RETURN-VALUE.

{include/i-rpcab.i}
{include/i-rpout.i}

/*view frame f-cabec.
view frame f-rodape.*/

FIND FIRST tt-param NO-ERROR.
IF NOT AVAIL tt-param THEN RETURN "NOK":U.

RUN pi-range-data-periodo IN THIS-PROCEDURE.


{utp/ut-liter.i "Buscando Produtores" * }
RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).

{utp/ut-liter.i "Pto Coleta" * }
ASSIGN c-lbl-pto-coleta = RETURN-VALUE.

{utp/ut-liter.i "Produtor" * }
ASSIGN c-lbl-produtor = RETURN-VALUE.

blk_carga:
FOR EACH produt-carg FIELDS(cdn-produt-rural num-carg dat-trans cod-pto-coleta cdn-produt-respons cdn-repos qtd-coleta cdn-identif) NO-LOCK
    WHERE produt-carg.cod-estabel       = tt-param.cod-estabel   
      AND produt-carg.cdn-produt-respons >= tt-param.cdn-produt-rural-ini
      AND produt-carg.cdn-produt-respons <= tt-param.cdn-produt-rural-fim 
      AND produt-carg.cod-pto-coleta     >= tt-param.cod-pto-coleta-ini
      AND produt-carg.cod-pto-coleta     <= tt-param.cod-pto-coleta-fim
      AND produt-carg.dat-trans          >= dt-dat-trans-ini
      AND produt-carg.dat-trans          <= dt-dat-trans-fim
      AND produt-carg.qtd-coleta         > 0,
    FIRST produt-rural FIELDS(cdn-grp-produt log-livre-1) NO-LOCK
    WHERE produt-rural.cdn-produt-rural = produt-carg.cdn-produt-respons,
    FIRST grp-produt FIELDS() NO-LOCK
    WHERE grp-produt.cdn-grp-produt  = produt-rural.cdn-grp-produt
      AND grp-produt.cdn-grp-produt >= tt-param.cdn-grp-produt-ini
      AND grp-produt.cdn-grp-produt <= tt-param.cdn-grp-produt-fim,
   FIRST carg-rural FIELDS(cod-estabel) NO-LOCK 
    WHERE carg-rural.num-carg  = produt-carg.num-carg 
      AND carg-rural.it-codigo = tt-param.it-codigo
      AND carg-rural.cod-rota >= tt-param.cod-rota-ini
      AND carg-rural.cod-rota <= tt-param.cod-rota-fim
       BY produt-carg.dat-trans
       BY produt-carg.cdn-produt-respons :       
    FIND FIRST tt-ponto-coleta    
         WHERE tt-ponto-coleta.cod-pto-coleta     = produt-carg.cod-pto-coleta
           AND tt-ponto-coleta.cdn-produt-respons = produt-carg.cdn-produt-respons
           AND tt-ponto-coleta.cdn-repos          = produt-carg.cdn-repos NO-ERROR.           
    IF AVAIL tt-ponto-coleta  THEN DO: 
    
        RUN pi-acompanhar IN h-acomp (INPUT c-lbl-pto-coleta + ": " + produt-carg.cod-pto-coleta  + "/ " + c-lbl-produtor + ": " + STRING(produt-carg.cdn-produt-rural)).
        /* ACUMULA QUANTIDADE COLETADA */
        ASSIGN tt-ponto-coleta.volume =  tt-ponto-coleta.volume  +  produt-carg.qtd-coleta.
        /* PARA CADA DATA DIFERENTE INCREMENTA QUANTIDADE DE ENTREGAS NO PERIODO */
        IF tt-ponto-coleta.dat-ult-trans <> produt-carg.dat-trans THEN DO:
             ASSIGN tt-ponto-coleta.dat-ult-trans = produt-carg.dat-trans
                    tt-ponto-coleta.num-entregas  = tt-ponto-coleta.num-entregas + 1.                    
        END.        
    END.
    ELSE DO:    
        RUN pi-acompanhar IN h-acomp (INPUT c-lbl-pto-coleta + ": " + produt-carg.cod-pto-coleta  + "/ " + c-lbl-produtor + ": " + STRING(produt-carg.cdn-produt-rural)).

        /* Inativos */
        IF NOT tt-param.l-inativos THEN DO:

          /* Ponto de Coleta */
          FIND FIRST pto-coleta NO-LOCK
               WHERE pto-coleta.cod-pto-coleta = produt-carg.cod-pto-coleta NO-ERROR.
          IF NOT AVAIL pto-coleta THEN
            NEXT blk_carga.

          IF AVAIL pto-coleta AND NOT pto-coleta.log-livre-1 THEN 
            NEXT blk_carga.
          
          /* Propriedade Rural */
          IF CAN-FIND(FIRST propried-rural
                      WHERE propried-rural.cod-propried = pto-coleta.cod-propried
                        AND NOT propried-rural.log-livre-1) THEN NEXT blk_carga.
            
          /* Produtor Rural */
          IF NOT produt-rural.log-livre-1 THEN NEXT blk_carga.

          /* Relacionamento    */
          IF CAN-FIND(FIRST produt-pto-coleta
                      WHERE produt-pto-coleta.cdn-produt-rural = produt-carg.cdn-produt-rural
                        AND produt-pto-coleta.cod-pto-coleta   = produt-carg.cod-pto-coleta
                        AND produt-pto-coleta.cod-propried     = pto-coleta.cod-propried
                        AND NOT produt-pto-coleta.log-livre-1) THEN NEXT blk_carga.
        END.
        
        CREATE tt-ponto-coleta.
        ASSIGN tt-ponto-coleta.cod-pto-coleta     = produt-carg.cod-pto-coleta      
               tt-ponto-coleta.cdn-produt-respons = produt-carg.cdn-produt-respons 
               tt-ponto-coleta.cdn-repos          = produt-carg.cdn-repos  
               tt-ponto-coleta.volume             = produt-carg.qtd-coleta
               tt-ponto-coleta.cod-estabel        = carg-rural.cod-estabel 
               tt-ponto-coleta.dat-ult-trans      = produt-carg.dat-trans               
               tt-ponto-coleta.num-entregas       = 1.               
    END.
    
    /* GUARDA OS PRODUTORES QUE FIZERAM ENTREGA EM DETERMINIADO PONTO DE COLETA */
    IF NOT CAN-FIND(FIRST tt-pto-coleta-produt
                    WHERE tt-pto-coleta-produt.cod-pto-coleta   = produt-carg.cod-pto-coleta
                      AND tt-pto-coleta-produt.cdn-produt-rural = produt-carg.cdn-produt-rural 
                      AND tt-pto-coleta-produt.cdn-repos        = produt-carg.cdn-repos 
                      AND tt-pto-coleta-produt.cdn-identif     <> produt-carg.cdn-identif) THEN DO:
                      
        CREATE tt-pto-coleta-produt.
        ASSIGN tt-pto-coleta-produt.cdn-identif        = produt-carg.cdn-identif      
               tt-pto-coleta-produt.cod-pto-coleta     = produt-carg.cod-pto-coleta      
               tt-pto-coleta-produt.cdn-produt-respons = produt-carg.cdn-produt-respons 
               tt-pto-coleta-produt.cdn-produt-rural   = produt-carg.cdn-produt-rural 
               tt-pto-coleta-produt.cdn-repos          = produt-carg.cdn-repos .
    END.
END.

{utp/ut-liter.i "Buscando Análises" * }
RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
 FOR EACH tt-ponto-coleta: 
    /* BUSCA TODOS OS PRODUTORES QUE FIZERAM ENTREGA NO PONTO DE COLETA */
    FOR EACH tt-pto-coleta-produt
       WHERE tt-pto-coleta-produt.cod-pto-coleta     = tt-ponto-coleta.cod-pto-coleta
         AND tt-pto-coleta-produt.cdn-produt-respons = tt-ponto-coleta.cdn-produt-respons
         AND tt-pto-coleta-produt.cdn-repos          = tt-ponto-coleta.cdn-repos :
         /* ACUMULA O NUMERO DE PRODUTORES QUE FIZERAM ENTREGA NO PONTO DE COLETA */
         ASSIGN tt-ponto-coleta.num-produtores = tt-ponto-coleta.num-produtores + 1.
         DELETE tt-pto-coleta-produt.
    END.
     
    ASSIGN tt-ponto-coleta.media-recep-dia = tt-ponto-coleta.volume / tt-ponto-coleta.num-entregas /* MEDIA DE RECEP‡ÆO DIARIA */
           tt-ponto-coleta.nome-produt     = fn-nome-produt(INPUT tt-ponto-coleta.cdn-produt-respons).
           
    FOR FIRST pto-coleta FIELDS(log-pto-coleta-coletiv val-latitude val-longitude cod-pto-coleta des-pto-coleta) NO-LOCK
        WHERE pto-coleta.cod-pto-coleta = tt-ponto-coleta.cod-pto-coleta:
        
        ASSIGN tt-ponto-coleta.pto-coletivo       = fn-coletivo(INPUT pto-coleta.log-pto-coleta-coletiv )
               tt-ponto-coleta.val-lat-pto-coleta = pto-coleta.val-latitude 
               tt-ponto-coleta.val-lon-pto-coleta = pto-coleta.val-longitude
               tt-ponto-coleta.des-pto-coleta     = pto-coleta.des-pto-coleta .
               
        FOR FIRST reposit FIELDS(qtd-capac) NO-LOCK
            WHERE reposit.cod-pto-coleta = pto-coleta.cod-pto-coleta
              AND reposit.cdn-repos      = tt-ponto-coleta.cdn-repos:
            ASSIGN tt-ponto-coleta.qtd-capac-repos = reposit.qtd-capac.  
        END.
        
        /* SE NAO ENCONTRAR ANALISE NO PERIODO MARCA COMO AMOSTRA NAO COLETADA */
        IF NOT CAN-FIND (FIRST analis-lab-period 
                         WHERE analis-lab-period.cod-pto-coleta = pto-coleta.cod-pto-coleta 
                           AND analis-lab-period.log-exter      = YES 
                           AND analis-lab-period.dat-analis    >= dt-dat-trans-ini 
                           AND analis-lab-period.dat-analis    <= dt-dat-trans-fim) THEN DO:
            ASSIGN tt-ponto-coleta.amostra-nao-coletada = "X":U.
        END.
        ELSE DO:
            /* BUSCA AS ANALISES DO PONTO DE COLETA REALIZADAS NO PERIODO */
            FOR EACH analis-lab-period FIELDS(cod-pto-coleta dat-analis nr-ficha) NO-LOCK
               WHERE analis-lab-period.cod-pto-coleta = pto-coleta.cod-pto-coleta 
                 AND analis-lab-period.log-exter      = YES 
                 AND analis-lab-period.dat-analis    >= dt-dat-trans-ini 
                 AND analis-lab-period.dat-analis    <= dt-dat-trans-fim
                 BREAK BY analis-lab-period.cod-pto-coleta 
                       BY analis-lab-period.dat-analis:                        
                 /* BUSCA RESULTADOS SOMENTE PARA COMPONENTES INFORMADOS EM TELA */      
                 FOR EACH res-fic-cq FIELDS(cod-exame cod-comp resultado) NO-LOCK
                    WHERE res-fic-cq.nr-ficha = analis-lab-period.nr-ficha
                    AND CAN-FIND(FIRST tt-digita 
                                 WHERE tt-digita.cod-exame = res-fic-cq.cod-exame
                                   AND tt-digita.cod-comp  = res-fic-cq.cod-comp):                                   
                    FIND FIRST tt-resultado
                         WHERE tt-resultado.cod-pto-coleta = analis-lab-period.cod-pto-coleta
                           AND tt-resultado.cod-exame      = res-fic-cq.cod-exame
                           AND tt-resultado.cod-comp       = res-fic-cq.cod-comp NO-ERROR.
                           
                    IF AVAIL tt-resultado THEN DO:                    
                        ASSIGN tt-resultado.valor = tt-resultado.valor + res-fic-cq.resultado
                               tt-resultado.cont  = tt-resultado.cont  + 1.
                    END.
                    ELSE DO:                    
                        RUN pi-acompanhar IN h-acomp (INPUT analis-lab-period.cod-pto-coleta).
                        CREATE tt-resultado.
                        ASSIGN tt-resultado.cod-pto-coleta = analis-lab-period.cod-pto-coleta
                               tt-resultado.cod-exame      = res-fic-cq.cod-exame
                               tt-resultado.cod-comp       = res-fic-cq.cod-comp
                               tt-resultado.valor          = res-fic-cq.resultado
                               tt-resultado.cont           = 1.
                    END.
                 END. /* FOR EACH res-fic-cq */
             END. /* .. FOR EACH analis-lab-period*/
        END.
    END. /*FIRST pto-coleta */  
 END. /* FOR EACH tt-ponto-coleta:  */
 
 
 /* INICIA GERACAO PLANILHA */
 
 {utp/ut-liter.i "Gerando Planilha" * }
RUN pi-inicializar in h-acomp (INPUT RETURN-VALUE).
 
/* cria colunas fixas planilha */
RUN piColumn IN h-utapi033 (INPUT 1,  INPUT "CHARACTER", INPUT c-tit-coluna[1],  INPUT "",                  INPUT "40").
RUN piColumn IN h-utapi033 (INPUT 2,  INPUT "CHARACTER", INPUT c-tit-coluna[2],  INPUT "",                  INPUT "50").
RUN piColumn IN h-utapi033 (INPUT 3,  INPUT "INTEGER",   INPUT c-tit-coluna[3],  INPUT ">>>,>>>,>>9",       INPUT "80"). 
RUN piColumn IN h-utapi033 (INPUT 4,  INPUT "CHARACTER", INPUT c-tit-coluna[4],  INPUT "",                  INPUT "130").
RUN piColumn IN h-utapi033 (INPUT 5,  INPUT "CHARACTER", INPUT c-tit-coluna[5],  INPUT "",                  INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 6,  INPUT "CHARACTER", INPUT c-tit-coluna[6],  INPUT "",                  INPUT "100").

RUN piColumn IN h-utapi033 (INPUT 7,  INPUT "CHARACTER", INPUT c-tit-coluna[7],  INPUT "",                  INPUT "50").


RUN piColumn IN h-utapi033 (INPUT 8,  INPUT "INTEGER",   INPUT c-tit-coluna[8],  INPUT ">>>,>>9",           INPUT "50").
RUN piColumn IN h-utapi033 (INPUT 9,  INPUT "INTEGER",   INPUT c-tit-coluna[9],  INPUT ">>9",               INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 10, INPUT "DECIMAL",   INPUT c-tit-coluna[10], INPUT ">>>>,>>>,>>9.9999", INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 11, INPUT "DECIMAL",   INPUT c-tit-coluna[11], INPUT ">>>>,>>>,>>9.9999", INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 12, INPUT "DECIMAL",   INPUT c-tit-coluna[12], INPUT ">>>>,>>>,>>9.9999", INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 13, INPUT "DECIMAL",   INPUT c-tit-coluna[13], INPUT "->>9.9999999",      INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 14, INPUT "DECIMAL",   INPUT c-tit-coluna[14], INPUT "->>9.9999999",      INPUT "100").
RUN piColumn IN h-utapi033 (INPUT 15, INPUT "CHARACTER", INPUT c-tit-coluna[15], INPUT "",                  INPUT "130").

/* Cria colunas dinamicamente conforme componentes da tt-digita */
FOR EACH tt-digita:
    ASSIGN i-num-col-dinamica = i-num-col-dinamica + 1.
    
    /* LISTA COM TODAS AS COLUNAS CRIADAS DINAMICAMENTE */
    IF c-todas-col-dinamic <> "" THEN 
        ASSIGN c-todas-col-dinamic = c-todas-col-dinamic + ",".                
    ASSIGN c-todas-col-dinamic = c-todas-col-dinamic +  STRING(i-num-col-dinamica).
      
      /* CRIA COLUNA DINAMICAMENTE PARA CADA COMPPONENTE DO EXAME */      
    RUN piColumn IN h-utapi033 (INPUT i-num-col-dinamica, INPUT "CHARACTER", INPUT tt-digita.desc-comp, INPUT "", INPUT "180").
  
    /* RASTREABILIDADE DA COLUNA */
    FOR EACH tt-resultado 
       WHERE tt-resultado.cod-exame = tt-digita.cod-exame 
         AND tt-resultado.cod-comp =  tt-digita.cod-comp:
        ASSIGN tt-resultado.coluna = i-num-col-dinamica.
    END.
END.

ASSIGN c-period =  SUBSTR(tt-param.period, 1,2) + "/" + SUBSTR(tt-param.period, 3,4).

{utp/ut-liter.i Gerando_planilha... *}
ASSIGN c-acomp = RETURN-VALUE.

/* CRIA LINHAS DA PLANILHA */
 FOR EACH tt-ponto-coleta: 
    RUN pi-acompanhar IN h-acomp (INPUT c-acomp).
    
    RUN piNewLine IN h-utapi033.    
    
    RUN piLine IN h-utapi033 (INPUT 1,   INPUT tt-ponto-coleta.cod-estabel          ).
    RUN piLine IN h-utapi033 (INPUT 2,   INPUT c-period                             ).
    RUN piLine IN h-utapi033 (INPUT 3,   INPUT tt-ponto-coleta.cdn-produt-respons   ).
    RUN piLine IN h-utapi033 (INPUT 4,   INPUT tt-ponto-coleta.nome-produt          ).
    RUN piLine IN h-utapi033 (INPUT 5,   INPUT tt-ponto-coleta.cod-pto-coleta       ).
    RUN piLine IN h-utapi033 (INPUT 6,   INPUT tt-ponto-coleta.des-pto-coleta       ).    
    RUN piLine IN h-utapi033 (INPUT 7,   INPUT tt-ponto-coleta.pto-coletivo         ).
    RUN piLine IN h-utapi033 (INPUT 8,   INPUT tt-ponto-coleta.cdn-repos            ).
    RUN piLine IN h-utapi033 (INPUT 9,   INPUT tt-ponto-coleta.num-produtores       ).
    RUN piLine IN h-utapi033 (INPUT 10,  INPUT tt-ponto-coleta.qtd-capac-repos      ).
    RUN piLine IN h-utapi033 (INPUT 11,  INPUT tt-ponto-coleta.volume               ).
    RUN piLine IN h-utapi033 (INPUT 12,  INPUT tt-ponto-coleta.media-recep-dia      ).
    RUN piLine IN h-utapi033 (INPUT 13,  INPUT tt-ponto-coleta.val-lat-pto-coleta   ).
    RUN piLine IN h-utapi033 (INPUT 14,  INPUT tt-ponto-coleta.val-lon-pto-coleta   ).
    RUN piLine IN h-utapi033 (INPUT 15,  INPUT tt-ponto-coleta.amostra-nao-coletada ).    
   
    ASSIGN c-col-dinamicas-criadas = "".     
    /* VERIFICA SE ENCONTROU ALGUM RESULTADO PARA O PONTO DE COLETA */
    IF CAN-FIND(FIRST tt-resultado
                WHERE tt-resultado.cod-pto-coleta = tt-ponto-coleta.cod-pto-coleta ) THEN DO:      
        /* VALORES DAS COLUNAS DINAMICAS */
        FOR EACH tt-resultado
           WHERE tt-resultado.cod-pto-coleta = tt-ponto-coleta.cod-pto-coleta
           BREAK BY tt-resultado.cod-pto-coleta BY tt-resultado.cod-exame BY tt-resultado.cod-comp:           
            
            IF LAST-OF(tt-resultado.cod-comp) THEN DO:
            
                ASSIGN l-avail = NO.
                
                IF CAN-FIND(FIRST it-comp-exame NO-LOCK
                            WHERE it-comp-exame.cod-exame = tt-resultado.cod-exame
                              AND it-comp-exame.cod-comp  = tt-resultado.cod-comp
                              AND it-comp-exame.it-codigo = tt-param.it-codigo) THEN DO:
                    FOR FIRST it-comp-exame FIELDS(result-min result-max) NO-LOCK
                        WHERE it-comp-exame.cod-exame = tt-resultado.cod-exame
                          AND it-comp-exame.cod-comp  = tt-resultado.cod-comp
                          AND it-comp-exame.it-codigo = tt-param.it-codigo:
                        /* INCREMENTA LISTA COM AS COLUNAS CRIADAS PARA ESTE PONTO DE COLETA */
                        ASSIGN c-col-dinamicas-criadas = c-col-dinamicas-criadas +  string(tt-resultado.coluna) + ","
                               l-avail                 = YES
                               d-resultado-min         = it-comp-exame.result-min
                               d-resultado-max         = it-comp-exame.result-max.
                    END.
                END.
                ELSE DO:
                    FOR FIRST comp-exame  FIELDS(result-min result-max) NO-LOCK
                        WHERE comp-exame.cod-exame = tt-resultado.cod-exame
                          AND comp-exame.cod-comp  = tt-resultado.cod-comp:
                        /* INCREMENTA LISTA COM AS COLUNAS CRIADAS PARA ESTE PONTO DE COLETA */
                        ASSIGN c-col-dinamicas-criadas = c-col-dinamicas-criadas +  string(tt-resultado.coluna) + ","
                               l-avail                 = YES
                               d-resultado-min         = comp-exame.result-min
                               d-resultado-max         = comp-exame.result-max.
                    END.
                END. 
                      
                IF l-avail THEN DO:                
                    /* Verifica se a media está dentra da faixa de resultados */
                    IF (tt-resultado.valor / tt-resultado.cont) < d-resultado-min OR  
                       (tt-resultado.valor / tt-resultado.cont) > d-resultado-max THEN DO:
                        RUN piLine IN h-utapi033 (INPUT tt-resultado.coluna,  INPUT c-txt-fora-padrao ).
                    END.
                    ELSE 
                        RUN piLine IN h-utapi033 (INPUT tt-resultado.coluna,  INPUT " " ). /* Para resultados dentro da faixa nao imprime nada na coluna */ 
                END.        
            END.               
               
            /* TRATAMENTO PARA IMPRESSAO DE ESPACO VAZIO NAS COLUNAS QUE NÃO TEM RESULTADO  */
            IF LAST-OF(tt-resultado.cod-pto-coleta) AND 
               LAST-OF(tt-resultado.cod-comp) THEN DO:                   
                REPEAT i-aux = 1 TO NUM-ENTRIES(c-todas-col-dinamic):  /* VARRE A LISTA COM TODAS AS COLUNAS CRIADAS DINAMICAMENTE  */
                    ASSIGN ch  = ENTRY(i-aux, c-todas-col-dinamic, ",").  /* PEGA O NUM DA COLUNA */
                    IF LOOKUP(ch, c-col-dinamicas-criadas, ",") = 0 THEN DO: /* VERIFICA SE EXISTE A COLUNA NA LISTA DE COLUNAS CRIADAS PARA O PTO COLETA  */ 
                        RUN piLine IN h-utapi033 (INPUT int(ch),  INPUT " " ). /* SE NAO EXISTIR, GRAVA ESPACO VAZIO */                               
                    END.
                END.
            END.
        END.       
    END. 
    ELSE DO: /* SE NAO ENCONTROU RESULTADO PARA O PONTO DE COLETA (tt-resultado)*/        
        /* 14 é o numero de colunas fixas . 
           Se i-num-col-dinamica > 15 indica que encontrou resultado(componente) para ALGUM PONTO DE COLETA
           O laco garante que seja impresso na planilha para as colunas criadas dinâmicamente.
           */
        IF i-num-col-dinamica > 15 THEN DO:            
            DO i-coluna = 16 TO i-num-col-dinamica:               
                 RUN piLine IN h-utapi033 (INPUT i-coluna, INPUT " ").
            END.
        END.    
    END.
 END. 
 
 
 IF tt-param.l-imp-param THEN DO:
     {utp/ut-liter.i at‚ *}
    ASSIGN c-lbl-ate = RETURN-VALUE.
 
    {utp/ut-liter.i SELE€ÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
    {utp/ut-liter.i "Rota" * }          
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.cod-rota-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-rota-fim).
    {utp/ut-liter.i "Grupo Produtor" * }           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.cdn-grp-produt-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-grp-produt-fim).
    {utp/ut-liter.i "Produtor" * } 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.cdn-produt-rural-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cdn-produt-rural-fim).   
    {utp/ut-liter.i "Pto. Coleta" * } 
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.cod-pto-coleta-ini) + " " + c-lbl-ate + " " + STRING(tt-param.cod-pto-coleta-fim).            
           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".
           
    {utp/ut-liter.i PAR¶METROS *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''. 

    
    FOR FIRST estabelec FIELDS(nome) NO-LOCK WHERE estabelec.cod-estabel = tt-param.cod-estabel: 
        ASSIGN c-nome-estabel = estabelec.nome.
    END.
    
           
    {utp/ut-liter.i "Estabelecimento" * }         
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.cod-estabel) + " - " + c-nome-estabel.
           
    {utp/ut-liter.i "Per¡odo" * }           
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.period, "99/9999").
           
    FOR FIRST item FIELDS(desc-item) NO-LOCK WHERE item.it-codigo = tt-param.it-codigo: 
        ASSIGN c-desc-item = item.desc-item .
    END.
    
    {utp/ut-liter.i "Item" * }                  
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.it-codigo) + ' - ' + c-desc-item.

    {utp/ut-liter.i "Listar Inativos" * }                  
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = STRING(tt-param.l-inativos, "Sim/NÆo").

    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = ""
           tt-param-planilha.valor     = "".
           
    {utp/ut-liter.i DIGITA€ÇO *}
    CREATE tt-param-planilha.
    ASSIGN tt-param-planilha.descricao = RETURN-VALUE
           tt-param-planilha.valor     = ''.
   
   {utp/ut-liter.i "Exame" *} 
   ASSIGN c-exame = RETURN-VALUE.
   {utp/ut-liter.i "Componente" *}
   ASSIGN c-componente =  RETURN-VALUE.

   FOR EACH tt-digita:
            
       CREATE tt-param-planilha.
       ASSIGN tt-param-planilha.descricao  = c-exame
               tt-param-planilha.valor     =  STRING(tt-digita.cod-exame) + " - " + tt-digita.desc-exame .     
         
        CREATE tt-param-planilha.
        ASSIGN tt-param-planilha.descricao = c-componente
               tt-param-planilha.valor     = STRING(tt-digita.cod-comp) + " - " + tt-digita.desc-comp .      
       
   END.   
           

    ASSIGN iParamColumnWidth[1] = 150
           iParamColumnWidth[2] = 300.

    RUN setParamColumnWidth IN h-utapi033 (INPUT iParamColumnWidth).
    RUN setTTParam          IN h-utapi033 (INPUT TABLE tt-param-planilha).
 
 END.
 

 

RUN piProcessa IN h-utapi033 (INPUT-OUTPUT tt-param.arquivo, INPUT "AQ0504":U, INPUT c-titulo-relat).

/* ELIMINA HANDLES */
RUN pi-finalizar IN h-acomp.
 
IF VALID-HANDLE(h-utapi033) THEN DO:
    DELETE PROCEDURE h-utapi033.
    ASSIGN h-utapi033 = ?.
END.

output close.

{include/i-rpclo.i}

RETURN "OK".


PROCEDURE pi-range-data-periodo:
/* ---------------------------------------------------------------------------
  Purpose: Alimenta variaveis do range de data de transação por período
               
  Parameters:  
  Notes:
---------------------------------------------------------------------------*/
    DEFINE VARIABLE c-period AS CHARACTER NO-UNDO.
    
    ASSIGN c-period = STRING(tt-param.period, "99/9999") 
           dt-dat-trans-ini = DATE("01/":U + c-period)
           dt-dat-trans-fim = DATE("01/":U + STRING(INT(ENTRY(1,c-period ,"/")) + 1) + "/" +  STRING(INT(ENTRY(2,c-period ,"/")))) - 1.
           
    RETURN "OK":U.
END PROCEDURE.


/* ************************  Function Implementations ***************** */
FUNCTION fn-nome-produt RETURNS CHARACTER
  ( pi-cdn-produt-rural AS INT ) :
  
   DEFINE VARIABLE c-nome AS CHARACTER NO-UNDO.
   
    FOR FIRST emitente FIELDS(nome-emit) NO-LOCK
        WHERE emitente.cod-emitente = pi-cdn-produt-rural:
        ASSIGN c-nome = emitente.nome-emit.       
    END.     
    RETURN c-nome.   /* Function return value. */
END FUNCTION.


FUNCTION fn-coletivo RETURNS CHARACTER
  ( p-log-pto-coleta-coletiv AS LOGICAL ):  
    IF p-log-pto-coleta-coletiv THEN DO:
        {utp/ut-liter.i "Sim" *}
    END.
    ELSE DO:
        {utp/ut-liter.i "NÆo" *}
    END.  
    RETURN  RETURN-VALUE.
END FUNCTION.





