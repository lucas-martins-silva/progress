DEFINE VARIABLE h-boin00982 AS HANDLE NO-UNDO.
DEFINE VARIABLE h-acomp     AS HANDLE NO-UNDO.

DEFINE BUFFER bf-produt-carg FOR produt-carg.

DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-destino-impressao  AS CHARACTER FORMAT "x(15)"             NO-UNDO.
                                     
DEFINE VARIABLE c-estabelec              AS CHARACTER FORMAT "X(49)"             NO-UNDO.
DEFINE VARIABLE c-rota                   AS CHARACTER FORMAT "X(65)"             NO-UNDO.
DEFINE VARIABLE c-situacao               AS CHARACTER FORMAT "X(20)"             NO-UNDO.
DEFINE VARIABLE c-situacao-pesagem       AS CHARACTER FORMAT "X(20)"             NO-UNDO.
DEFINE VARIABLE c-transportadora         AS CHARACTER FORMAT "X(47)"             NO-UNDO.
DEFINE VARIABLE d-km-rodados             AS DECIMAL   FORMAT ">,>>>,>>9.999"     NO-UNDO.
DEFINE VARIABLE c-item                   AS CHARACTER FORMAT "X(80)"             NO-UNDO.
DEFINE VARIABLE c-referencia             AS CHARACTER FORMAT "X(43)"             NO-UNDO.
DEFINE VARIABLE d-diferenca              AS DECIMAL   FORMAT ">>>>,>>>,>>9.9999" NO-UNDO.
DEFINE VARIABLE c-usuario                AS CHARACTER FORMAT "X(65)"             NO-UNDO.

DEFINE VARIABLE c-traco-pesagem          AS CHARACTER FORMAT "X(80)"              NO-UNDO. 
DEFINE VARIABLE c-traco-pesagem-2        AS CHARACTER FORMAT "X(80)"              NO-UNDO. 
DEFINE VARIABLE c-tit-pesagem            AS CHARACTER FORMAT "X(129)"             NO-UNDO.
DEFINE VARIABLE c-lbl-seq                AS CHARACTER FORMAT "X(3)"               NO-UNDO.
DEFINE VARIABLE c-lbl-pesagem            AS CHARACTER FORMAT "X(7)"               NO-UNDO.
DEFINE VARIABLE c-lbl-peso               AS CHARACTER FORMAT "X(4)"               NO-UNDO.
DEFINE VARIABLE c-lbl-qtde               AS CHARACTER FORMAT "X(10)"              NO-UNDO.
DEFINE VARIABLE c-lbl-situcao            AS CHARACTER FORMAT "X(8)"               NO-UNDO.
                                         
DEFINE VARIABLE c-traco-liber            AS CHARACTER FORMAT "X(40)"              NO-UNDO. 
DEFINE VARIABLE c-traco-liber-2          AS CHARACTER FORMAT "X(129)"             NO-UNDO. 
DEFINE VARIABLE c-tit-liber              AS CHARACTER FORMAT "X(129)"             NO-UNDO.
DEFINE VARIABLE c-liberacao              AS CHARACTER FORMAT "X(16)"              NO-UNDO. 
DEFINE VARIABLE c-analise                AS CHARACTER FORMAT "X(9)"               NO-UNDO.
DEFINE VARIABLE c-lbl-liber              AS CHARACTER FORMAT "X(9)"               NO-UNDO.
DEFINE VARIABLE c-lbl-analise            AS CHARACTER FORMAT "X(7)"               NO-UNDO.
DEFINE VARIABLE c-lbl-compart            AS CHARACTER FORMAT "X(7)"               NO-UNDO.
DEFINE VARIABLE c-lbl-lote               AS CHARACTER FORMAT "X(4)"               NO-UNDO.
DEFINE VARIABLE c-lbl-dt-valid-lote      AS CHARACTER FORMAT "X(11)"              NO-UNDO.
DEFINE VARIABLE c-lbl-dep                AS CHARACTER FORMAT "X(3)"               NO-UNDO.
DEFINE VARIABLE c-lbl-roteiro            AS CHARACTER FORMAT "X(7)"               NO-UNDO.
DEFINE VARIABLE c-lbl-rejei              AS CHARACTER FORMAT "X(3)"               NO-UNDO.
DEFINE VARIABLE c-lbl-obs                AS CHARACTER FORMAT "X(19)"              NO-UNDO.
DEFINE VARIABLE c-lbl-pto-coleta         AS CHARACTER FORMAT "X(12)"              NO-UNDO.
                                         
DEFINE VARIABLE i-idi-aprova             AS INTEGER                               NO-UNDO.
                                         
DEFINE VARIABLE c-traco-produt           AS CHARACTER FORMAT "X(23)"              NO-UNDO. 
DEFINE VARIABLE c-traco-produt-2         AS CHARACTER FORMAT "X(70)"              NO-UNDO.
DEFINE VARIABLE c-tit-produt             AS CHARACTER FORMAT "X(70)"              NO-UNDO. 
DEFINE VARIABLE c-lbl-produtor           AS CHARACTER FORMAT "X(8)"               NO-UNDO.  
DEFINE VARIABLE c-lbl-responsavel        AS CHARACTER FORMAT "X(11)"              NO-UNDO.
DEFINE VARIABLE c-respons                AS CHARACTER FORMAT "X(3)"               NO-UNDO.
DEFINE VARIABLE c-sim                    AS CHARACTER FORMAT "X(3)"               NO-UNDO.
DEFINE VARIABLE c-nao                    AS CHARACTER FORMAT "X(3)"               NO-UNDO.
DEFINE VARIABLE c-rota-padrao            AS CHARACTER FORMAT "X(12)"              NO-UNDO.
DEFINE VARIABLE c-grupo-prod             AS CHARACTER FORMAT "X(20)"              NO-UNDO.
DEFINE VARIABLE i-cont-prod              AS INTEGER                               NO-UNDO.
DEFINE VARIABLE c-traco-total-prod       AS CHARACTER FORMAT "X(34)"              NO-UNDO.
DEFINE VARIABLE c-nome-emit              AS CHARACTER FORMAT "X(38)"              NO-UNDO.
DEFINE VARIABLE c-repos                  AS CHARACTER FORMAT "X(4)"               NO-UNDO.

DEFINE VARIABLE de-total-prod            AS DECIMAL FORMAT ">>>>>9.9999"          NO-UNDO.
DEFINE VARIABLE de-total-afer            AS DECIMAL FORMAT ">>>>>9.9999"          NO-UNDO.
DEFINE VARIABLE de-atesto                AS DECIMAL FORMAT "->>>>>9.9999"         NO-UNDO.

DEFINE VARIABLE c-lbl-cont-prod          AS CHARACTER FORMAT "X(18)"              NO-UNDO.
DEFINE VARIABLE c-lbl-total-prod         AS CHARACTER FORMAT "X(22)"              NO-UNDO.
DEFINE VARIABLE c-lbl-total-afer         AS CHARACTER FORMAT "X(15)"              NO-UNDO.
DEFINE VARIABLE c-lbl-total-atesto       AS CHARACTER FORMAT "X(7)"              NO-UNDO.

DEFINE VARIABLE c-traco-nc               AS CHARACTER FORMAT "X(57)"              NO-UNDO. 
DEFINE VARIABLE c-traco-nc-2             AS CHARACTER FORMAT "X(129)"             NO-UNDO. 
DEFINE VARIABLE c-tit-nc                 AS CHARACTER FORMAT "X(129)"             NO-UNDO.
DEFINE VARIABLE c-lbl-nc                 AS CHARACTER FORMAT "X(2)"               NO-UNDO.
DEFINE VARIABLE c-lbl-tipo               AS CHARACTER FORMAT "X(4)"               NO-UNDO.
DEFINE VARIABLE c-lbl-carga              AS CHARACTER FORMAT "X(5)"               NO-UNDO.
DEFINE VARIABLE c-lbl-data               AS CHARACTER FORMAT "X(4)"               NO-UNDO.
DEFINE VARIABLE c-situacao-nc            AS CHARACTER FORMAT "X(10)"              NO-UNDO.
DEFINE VARIABLE c-tipo                   AS CHARACTER FORMAT "X(10)"              NO-UNDO.

DEFINE VARIABLE i-idi-tip-aferic         AS INTEGER                               NO-UNDO.
      
DEFINE VARIABLE c-traco-total            AS CHARACTER FORMAT "X(23)"              NO-UNDO.
DEFINE VARIABLE c-total                  AS CHARACTER FORMAT "X(5)"               NO-UNDO.
DEFINE VARIABLE d-total                  LIKE produt-carg.qtd-coleta              NO-UNDO.

DEFINE VARIABLE c-pesagem                AS CHARACTER FORMAT "X(3)"               NO-UNDO.    
DEFINE VARIABLE c-liber-carg             AS CHARACTER FORMAT "X(3)"               NO-UNDO.    
DEFINE VARIABLE c-produtores             AS CHARACTER FORMAT "X(3)"               NO-UNDO.    
DEFINE VARIABLE c-nc                     AS CHARACTER FORMAT "X(3)"               NO-UNDO.    
DEFINE VARIABLE c-sit-param              AS CHARACTER FORMAT "X(10)"              NO-UNDO.    
DEFINE VARIABLE c-imp-param              AS CHARACTER FORMAT "X(3)"               NO-UNDO.   

{utp/ut-liter.i PESAGENS * }
ASSIGN c-tit-pesagem = RETURN-VALUE.
{utp/ut-liter.i Seq * }
ASSIGN c-lbl-seq     = RETURN-VALUE.
{utp/ut-liter.i Pesagem * }
ASSIGN c-lbl-pesagem = RETURN-VALUE.
{utp/ut-liter.i Peso * }
ASSIGN c-lbl-peso    = RETURN-VALUE.
{utp/ut-liter.i Quantidade * }
ASSIGN c-lbl-qtde    = RETURN-VALUE.
{utp/ut-liter.i Situa‡Æo * }
ASSIGN c-lbl-situcao = RETURN-VALUE.

{utp/ut-liter.i LIBERA€ÇO_DE_CARGAS *}
ASSIGN c-tit-liber          = RETURN-VALUE.
{utp/ut-liter.i Libera‡Æo * }
ASSIGN c-lbl-liber         = RETURN-VALUE.
{utp/ut-liter.i An lise * }
ASSIGN c-lbl-analise       = RETURN-VALUE.
{utp/ut-liter.i Compart * }
ASSIGN c-lbl-compart       = RETURN-VALUE.
{utp/ut-liter.i Lote * }
ASSIGN c-lbl-lote          = RETURN-VALUE.
{utp/ut-liter.i Dt_Val_Lote * }
ASSIGN c-lbl-dt-valid-lote = RETURN-VALUE.
{utp/ut-liter.i Dep * }
ASSIGN c-lbl-dep           = RETURN-VALUE.
{utp/ut-liter.i Roteiro * }
ASSIGN c-lbl-roteiro       = RETURN-VALUE.
{utp/ut-liter.i Rej * }
ASSIGN c-lbl-rejei         = RETURN-VALUE.
{utp/ut-liter.i Observa‡Æo * }
ASSIGN c-lbl-obs           = RETURN-VALUE.

{utp/ut-liter.i PRODUTORES * }
ASSIGN c-tit-produt = RETURN-VALUE.
{utp/ut-liter.i Produtor * }
ASSIGN c-lbl-produtor       = RETURN-VALUE.
{utp/ut-liter.i Respons vel * }
ASSIGN c-lbl-responsavel    = RETURN-VALUE.
{utp/ut-liter.i Sim * }
ASSIGN c-sim                = RETURN-VALUE.
{utp/ut-liter.i NÆo * }
ASSIGN c-nao                = RETURN-VALUE.
{utp/ut-liter.i N._de_Produtores: * }
ASSIGN c-lbl-cont-prod      = RETURN-VALUE.
{utp/ut-liter.i Volume_dos_Produtores: * }
ASSIGN c-lbl-total-prod     = RETURN-VALUE.
{utp/ut-liter.i Volume_Aferido: * }
ASSIGN c-lbl-total-afer     = RETURN-VALUE.
{utp/ut-liter.i Atesto: * }
ASSIGN c-lbl-total-atesto   = RETURN-VALUE.

{utp/ut-liter.i NCs_da_Carga *}
{utp/ut-liter.i NÇO_CONFORMIDADES_DA_CARGA *}
ASSIGN c-tit-nc     = RETURN-VALUE.
{utp/ut-liter.i NC * }
ASSIGN c-lbl-nc     = RETURN-VALUE.
{utp/ut-liter.i Ponto_Coleta * }
ASSIGN c-lbl-pto-coleta = RETURN-VALUE.
{utp/ut-liter.i Tipo * }
ASSIGN c-lbl-tipo   = RETURN-VALUE.
{utp/ut-liter.i Carga * }
ASSIGN c-lbl-carga  = RETURN-VALUE.
{utp/ut-liter.i Data * }
ASSIGN c-lbl-data   = RETURN-VALUE.

FORM carg-rural.num-carg          COLON 17  LABEL "Carga" 
     c-estabelec                  COLON 48  LABEL "Estabelecimento" FORMAT "X(49)" SKIP
     carg-rural.cod-carga         COLON 17  LABEL "C¢digo"          FORMAT "X(15)" 
     c-rota                       COLON 48  LABEL "Rota"            FORMAT "X(65)"  
     carg-rural.dat-entr          COLON 17  LABEL "Data Carga"
     carg-rural.hra-entr          COLON 48                          FORMAT "X(8)"
     carg-rural.dat-trans         COLON 17  LABEL "Data Transa‡Æo"     
     c-situacao                   COLON 48  LABEL "Situa‡Æo"        FORMAT "X(20)" 
     c-usuario                    COLON 81  LABEL "Usu rio"         FORMAT "X(50)" SKIP 
     c-transportadora             COLON 17  LABEL "Transportadora"  FORMAT "X(47)" SKIP                        
     carg-rural.cod-placa         COLON 17 
     carg-rural.cod-inter-veic    COLON 48  LABEL "Ve¡culo"
     carg-rural.cod-uf            COLON 81  LABEL "UF"
     carg-rural.qti-comptmento    COLON 111 LABEL "Compartimentos"  SKIP
     carg-rural.val-hodom-inicial COLON 17  LABEL "KM Inicial" 
     carg-rural.val-hodom-Final   COLON 48  LABEL "KM Final" 
     d-km-rodados                 COLON 81  LABEL "KM Rodados"      FORMAT ">,>>>,>>9.999"      
     c-item                       COLON 17  LABEL "Item"            FORMAT "X(50)"  
     c-referencia                 COLON 81  LABEL "Referˆncia"      FORMAT "X(50)" SKIP 
     carg-rural.qtd-coleta        COLON 17  LABEL "Qtde Coletada"   
     carg-rural.qtd-aferid        COLON 48  LABEL "Qtde Aferida"    
     d-diferenca                  COLON 81  LABEL "Diferen‡a"       FORMAT "->>>>,>>>,>>9.9999" SKIP
     carg-rural.val-densidade     COLON 17  LABEL "Densidade"
     carg-rural.val-frete         COLON 48  LABEL "Valor Frete"     SKIP
     WITH STREAM-IO NO-BOX SIDE-LABEL WIDTH 132 FRAME f-carga.

ASSIGN c-traco-pesagem   = FILL('-', 58)
       c-tit-pesagem     = "*" + c-traco-pesagem + " " + c-tit-pesagem + " " + c-traco-pesagem + "-*"
       c-traco-pesagem-2 = FILL('-', 7) + " " + FILL('-', 17) + " " + FILL('-', 17) + " " + FILL('-', 17) + " " + FILL('-', 15).
       
FORM c-tit-pesagem     COLON 2 SKIP
     c-lbl-seq         COLON 2 
     c-lbl-pesagem     COLON 10
     c-lbl-peso        COLON 28
     c-lbl-qtde        COLON 46 
     c-lbl-situcao     COLON 64 SKIP
     c-traco-pesagem-2 COLON 2    
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-tit-pesagem.
  
FORM pesagem.cdn-pesagem     COLON 2
     pesagem.val-peso-balan  COLON 10 
     pesagem.val-peso-aferid COLON 28
     pesagem.val-quant       COLON 46
     c-situacao-pesagem      COLON 64 
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-pesagem.
     
     
FORM SKIP  WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-skip.     

ASSIGN c-traco-liber   = FILL('-', 53)
       c-tit-liber     = "*" + c-traco-liber + " " + c-tit-liber + " " + c-traco-liber + "*"
       c-traco-liber-2 = FILL('-', 16) + " " + FILL('-', 9)  + " " + FILL('-', 7) + " " + 
                         FILL('-', 10) + " " + FILL('-', 11) + " " + FILL('-', 3) + " " +  
                         FILL('-', 7)  + " " + FILL('-', 17) + " " + FILL('-', 17)+ " " + 
                         FILL('-', 3)  + " " + FILL('-', 19).
     
FORM c-tit-liber         COLON 2 SKIP
     c-lbl-liber         COLON 2      
     c-lbl-analise       COLON 19
     c-lbl-compart       COLON 29
     c-lbl-lote          COLON 37 
     c-lbl-dt-valid-lote COLON 48
     c-lbl-dep           COLON 60
     c-lbl-roteiro       COLON 64
     c-lbl-qtde          COLON 72
     c-lbl-peso          COLON 90
     c-lbl-rejei         COLON 108
     c-lbl-obs           COLON 112 SKIP 
     c-traco-liber-2     COLON 2
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-tit-liber-carg.
     
FORM c-liberacao             COLON 2      
     c-analise               COLON 19
     liber-carg.cdn-compart  COLON 33
     liber-carg.lote         COLON 37 FORMAT "X(10)"
     liber-carg.dt-vali-lote COLON 48
     liber-carg.cod-depos    COLON 60
     liber-carg.nr-ficha     COLON 63
     liber-carg.val-quant    COLON 72
     liber-carg.val-peso-liq COLON 90
     liber-carg.codigo-rejei COLON 108
     liber-carg.cod-obs      COLON 112 FORMAT "X(19)" 
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-liber-carg.
     
ASSIGN c-traco-produt   = FILL('-', 22)
       c-tit-produt     = "*" + c-traco-produt + " " + c-tit-produt  + " " + c-traco-produt  + "*"
       c-traco-produt-2   = FILL('-', 9) + " " + FILL('-',11) + " " + FILL('-',40) + " " +  FILL('-',23).
       
ASSIGN c-traco-total-prod = FILL('-', 34).
       
FORM c-traco-total-prod COLON 32 SKIP
     c-lbl-cont-prod    COLON 37 
     i-cont-prod        COLON 56 SKIP
     c-lbl-total-prod   COLON 32
     de-total-prod      COLON 57 SKIP
     c-lbl-total-afer   COLON 39
     de-total-afer      COLON 57 SKIP
     c-lbl-total-atesto COLON 47
     de-atesto          COLON 56 
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 120 FRAME f-total-prod.
      
FORM tt-produt-carg-aux.cdn-produt-rural COLUMN-LABEL "Produtor" 
     tt-produt-carg-aux.c-respons        COLUMN-LABEL "Res"
     tt-produt-carg-aux.c-nome-emit      COLUMN-LABEL "Nome"
     tt-produt-carg-aux.qtd-coleta       COLUMN-LABEL "Quantidade"        FORMAT ">>>>>9.99"     
     tt-produt-carg-aux.cdn-compart      COLUMN-LABEL "Comp"             
     tt-produt-carg-aux.c-repos          COLUMN-LABEL "Repo"              FORMAT "X(4)"
     tt-produt-carg-aux.val-temperat     COLUMN-LABEL "Temp"              FORMAT "->9.99" 
     tt-produt-carg-aux.c-rota-padrao    COLUMN-LABEL "Rota PadrÆo"
     tt-produt-carg-aux.cod-pto-coleta   COLUMN-LABEL "Pto. Coleta"
     tt-produt-carg-aux.c-grupo-prod     COLUMN-LABEL "Grupo"             FORMAT "X(24)"
     with width 156 down frame f-produt stream-io.
 
{utp/ut-liter.i "TOTAL" * }
ASSIGN c-total = RETURN-VALUE.      
ASSIGN c-traco-total = FILL('-',23).
      
FORM c-traco-total COLON 45 SKIP
     c-total       COLON 40 
     d-total       COLON 51 
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 100 FRAME f-tot-produt.

ASSIGN c-traco-nc   = FILL("-", 49)
       c-tit-nc     =  "*" + c-traco-nc + " " + c-tit-nc + " " + c-traco-nc + "-*"
       c-traco-nc-2 = FILL("-", 9)  + " " + 
                      FILL("-", 10)  + " " + 
                      FILL("-", 12) + " " + 
                      FILL("-", 7)  + " " + 
                      FILL("-", 10) + " " + 
                      FILL("-", 17) + " " + 
                      FILL("-", 10).

FORM c-tit-nc         COLON 2 SKIP
     c-lbl-nc         COLON 2
     c-lbl-tipo       COLON 12
     c-lbl-pto-coleta COLON 23
     c-lbl-compart    COLON 36
     c-lbl-data       COLON 44
     c-lbl-qtde       COLON 55
     c-lbl-situcao    COLON 73  SKIP
     c-traco-nc-2     COLON 2
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-tit-nc.     

FORM naocfedade-carg.cdn-naocfedade COLON 2 FORMAT ">>>>>>>>9"
     c-tipo                         COLON 12
     naocfedade-carg.cod-pto-coleta COLON 23
     naocfedade-carg.cdn-compart    COLON 40
     naocfedade-carg.dat-trans      COLON 44
     naocfedade-carg.val-quant      COLON 55
     c-situacao-nc                  COLON 73 SKIP
     WITH STREAM-IO NO-BOX NO-LABEL WIDTH 132 FRAME f-nc.
     
FORM "SELE€ÇO"                 AT 01 
     SKIP(01)
     "Estabelecimento:" AT 05 tt-param.cod-estabel-ini  NO-LABEL "|< >|" AT 38 tt-param.cod-estabel-fim  NO-LABEL SKIP 
     "Carga:"           AT 15 tt-param.num-carg-ini     NO-LABEL "|< >|" AT 38 tt-param.num-carg-fim     NO-LABEL SKIP 
     "C¢digo:"          AT 14 tt-param.cod-carga-ini    NO-LABEL "|< >|" AT 38 tt-param.cod-carga-fim    NO-LABEL SKIP    
     "Placa:"           AT 15 tt-param.cod-placa-ini    NO-LABEL "|< >|" AT 38 tt-param.cod-placa-fim    NO-LABEL SKIP    
     "Rota:"            AT 16 tt-param.cod-rota-ini     NO-LABEL "|< >|" AT 38 tt-param.cod-rota-fim     NO-LABEL SKIP    
     "Transportador:"   AT 07 tt-param.cod-transp-ini   NO-LABEL "|< >|" AT 38 tt-param.cod-transp-fim   NO-LABEL SKIP    
     "Data Transa‡Æo:"  AT 06 tt-param.dat-trans-ini    NO-LABEL "|< >|" AT 38 tt-param.dat-trans-fim    NO-LABEL SKIP
     "Data Entrada:"    AT 08 tt-param.dat-entr-ini     NO-LABEL "|< >|" AT 38 tt-param.dat-entr-fim     NO-LABEL skip(02)
     
     "PAR¶METROS"                  AT 01 SKIP(01)
     "Situa‡Æo: "                  AT 05 c-sit-param  NO-LABEL SKIP(01)
     "Listar"                      AT 05 SKIP
     "Pesagem:"                    AT 25 c-pesagem    NO-LABEL SKIP
     "Libera‡Æo de Carga:"         AT 14 c-liber-carg NO-LABEL SKIP
     "Produtores:"                 AT 22 c-produtores NO-LABEL SKIP
     "NÆo Conformidades da Carga:" AT 06 c-nc         NO-LABEL SKIP (03)
     "IMPRESSÇO" AT 01    
     SKIP(01)
     "Destino:" AT 05 tt-param.destino NO-LABEL SKIP 
     "Arquivo:" AT 05 tt-param.arquivo NO-LABEL SKIP 
     "Usu rio:" AT 05 tt-param.usuario NO-LABEL   
     WITH SIDE-LABELS NO-BOX STREAM-IO WIDTH 132 FRAME f-param.
   
 

   
