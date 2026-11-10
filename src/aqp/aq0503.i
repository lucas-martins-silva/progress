DEFINE VARIABLE h-acomp             AS HANDLE                   NO-UNDO.
DEFINE VARIABLE c-acomp             AS CHARACTER EXTENT 2       NO-UNDO.
DEFINE VARIABLE c-label-params      AS CHARACTER EXTENT 11      NO-UNDO.
DEFINE VARIABLE c-label-campos      AS CHARACTER EXTENT 6       NO-UNDO.
DEFINE VARIABLE c-traco             AS CHARACTER EXTENT 2       NO-UNDO.
DEFINE VARIABLE c-regra             AS CHARACTER EXTENT 7       NO-UNDO.

DEFINE TEMP-TABLE tt-param NO-UNDO
    FIELD destino             AS INTEGER
    FIELD arquivo             AS CHARACTER FORMAT "x(35)":U
    FIELD usuario             AS CHARACTER FORMAT "x(12)":U
    FIELD data-exec           AS DATE
    FIELD hora-exec           AS INTEGER
    FIELD cod-transp-ini      AS INTEGER
    FIELD cod-transp-fim      AS INTEGER
    FIELD dt-trans-ini        AS DATE FORMAT "99/99/9999"
    FIELD dt-trans-fim        AS DATE FORMAT "99/99/9999"
    FIELD cod-estab-ini       AS CHARACTER FORMAT "X(5)":U
    FIELD cod-estab-fim       AS CHARACTER FORMAT "X(5)":U
    FIELD cod-rota-ini        AS CHARACTER FORMAT "X(12)":U
    FIELD cod-rota-fim        AS CHARACTER FORMAT "X(12)":U
    FIELD it-codigo-ini       AS CHARACTER FORMAT "X(16)":U
    FIELD it-codigo-fim       AS CHARACTER FORMAT "X(16)":U
    FIELD cod-placa-ini       AS CHARACTER FORMAT "X(10)":U
    FIELD cod-placa-fim       AS CHARACTER FORMAT "X(10)":U
    FIELD atualiza-frete-carg AS LOGICAL
    FIELD imp-param           AS LOGICAL
    FIELD lista-detalhado     AS LOGICAL.
    
DEFINE TEMP-TABLE tt-digita NO-UNDO
    FIELD ordem            AS INTEGER   FORMAT ">>>>9":U
    FIELD exemplo          AS CHARACTER FORMAT "X(30)":U
    INDEX id ordem.    
    
DEF TEMP-TABLE tt-raw-digita NO-UNDO
    FIELD raw-digita  AS RAW.    
   
DEFINE TEMP-TABLE tt-carga-preco NO-UNDO
     LIKE carg-rural
    FIELD cdn-tip-veic           LIKE preco-frete-coleta.cdn-tip-veic   
    FIELD des-tip-veic           AS CHARACTER  
    FIELD dat-inic-vigenc        LIKE preco-frete-coleta.dat-inic-vigenc     
    FIELD dat-fim-vigenc         LIKE preco-frete-coleta.dat-fim-vigenc      
    FIELD val-unit-frete-km      LIKE preco-frete-coleta.val-unit-frete-km   
    FIELD val-unit-frete-quant   LIKE preco-frete-coleta.val-unit-frete-quant
    FIELD val-fix-frete          LIKE preco-frete-coleta.val-fix-frete   
    FIELD valor-frete-pagar      LIKE carg-rural.val-frete
    FIELD valor-frete-padrao     LIKE carg-rural.val-frete
    FIELD qtd-capac-vol          LIKE mdfe-veic.qtd-capac-vol
    FIELD km-rodados             LIKE carg-rural.val-hodom-inicial
    FIELD vl-frete-qtde          LIKE preco-frete-coleta.val-unit-frete-km  
    FIELD percent-ocup           LIKE carg-rural.qtd-coleta
    FIELD lt-km                  LIKE carg-rural.qtd-coleta
    FIELD nome                   LIKE transporte.nome
    FIELD regra-utiliz           AS CHARACTER
    FIELD qtd-pto-col            AS INTEGER FORMAT ">>9"
    FIELD qtd-pto-col-bon        AS INTEGER FORMAT ">>9"
    FIELD motiv-nao-coleta       AS CHARACTER
    FIELD idi-nao-coleta         AS INTEGER
    FIELD val-unit-bonus-pto-col LIKE preco-frete-coleta.val-unit-bonus-pto-col
    FIELD val-unit-bonus-km      LIKE preco-frete-coleta.val-unit-bonus-km
    FIELD km-bonif               LIKE carg-rural.val-hodom-inicial
    FIELD desc-sit-carg          AS CHARACTER
    FIELD val-percur             LIKE rota-coleta.val-percur
    FIELD dif-qtde               LIKE produt-carg.qtd-coleta
    FIELD qtd-reprovada          LIKE produt-carg.qtd-coleta
    FIELD num-pto-coletados      AS INTEGER FORMAT ">9"
    FIELD val-debit-transp       LIKE carg-rural.val-frete
    FIELD val-liq-frete          LIKE carg-rural.val-frete
    FIELD des-rota               LIKE rota-coleta.des-rota.
    
    
    
DEFINE TEMP-TABLE tt-param-planilha NO-UNDO
    FIELD descricao AS CHARACTER
    FIELD valor     AS CHARACTER.

DEFINE TEMP-TABLE tt-erros no-undo
    FIELD cod-erro   AS INTEGER
    FIELD desc-error AS CHAR    FORMAT "x(256)".    

{utp/ut-liter.i Sele‡Æo * }
ASSIGN c-label-params[1] = RETURN-VALUE.
{utp/ut-liter.i Parƒmetros * }
ASSIGN c-label-params[2] = RETURN-VALUE.
{utp/ut-liter.i Atualiza_valor_frete_nas_cargas * }
ASSIGN c-label-params[3] = RETURN-VALUE.
{utp/ut-liter.i ImpressÆo * }
ASSIGN c-label-params[4] = RETURN-VALUE.
{utp/ut-liter.i Destino * }
ASSIGN c-label-params[5] = RETURN-VALUE.
{utp/ut-liter.i Arquivo_de_sa¡da * }
ASSIGN c-label-params[6] = RETURN-VALUE.
{utp/ut-liter.i Relat¢rio_de_c lculo_frete_coleta_gerado_no_diret¢rio * }
ASSIGN c-label-params[7] = RETURN-VALUE.
{utp/ut-liter.i Erros_Gera‡Æo_Planilha * }
ASSIGN c-label-params[8] = RETURN-VALUE.
{utp/ut-liter.i Erro * }
ASSIGN c-label-params[9] = RETURN-VALUE.
{utp/ut-liter.i Descri‡Æo * }
ASSIGN c-label-params[10] = RETURN-VALUE.
{utp/ut-liter.i Lista_Detalhado * }
ASSIGN c-label-params[11] = RETURN-VALUE.

ASSIGN c-traco[1] = FILL("-", 4)
       c-traco[2] = FILL("-", 100).

{utp/ut-liter.i Transportador * }
ASSIGN c-label-campos[1] = RETURN-VALUE.
{utp/ut-liter.i Data_transa‡Æo * }
ASSIGN c-label-campos[2] = RETURN-VALUE.
{utp/ut-liter.i Estabelecimento * }
ASSIGN c-label-campos[3] = RETURN-VALUE.
{utp/ut-liter.i Rota * }
ASSIGN c-label-campos[4] = RETURN-VALUE.
{utp/ut-liter.i Item * }
ASSIGN c-label-campos[5] = RETURN-VALUE.
{utp/ut-liter.i Placa * }
ASSIGN c-label-campos[6] = RETURN-VALUE.

ASSIGN c-regra[1] = STRING(c-label-campos[3],"x(5)")  + ": &1":U
       c-regra[2] = c-label-campos[4] + ": &2":U
       c-regra[3] = STRING(c-label-campos[1],"x(6)") + ": &3":U
       c-regra[5] = c-label-campos[5] + ": &5":U.
       
{utp/ut-liter.i Tipo_ve¡culo * }
ASSIGN c-regra[4] = RETURN-VALUE + ": &4":U.
{utp/ut-liter.i Ini_Vigˆncia * r}   
ASSIGN c-regra[6] = RETURN-VALUE +  ": &6":U.
{utp/ut-liter.i Fim_Vigˆncia * r}    
ASSIGN c-regra[7] = RETURN-VALUE +  ": &7":U.

{utp/ut-liter.i Buscado_cargas * }
ASSIGN c-acomp[1] = RETURN-VALUE.
{utp/ut-liter.i Buscado_regras_de_pre‡o * }
ASSIGN c-acomp[2] = RETURN-VALUE. 
