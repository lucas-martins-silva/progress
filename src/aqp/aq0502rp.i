&GLOBAL-DEFINE COLUNAS 11

DEFINE VARIABLE c-label-coluna AS CHARACTER EXTENT {&COLUNAS} NO-UNDO.
DEFINE VARIABLE d-largura      AS DECIMAL   EXTENT {&COLUNAS} NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE i-ep-codigo-usuario AS CHARACTER NO-UNDO.

DEFINE VARIABLE c-sim-nao     AS CHARACTER EXTENT 2 NO-UNDO.
DEFINE VARIABLE i-coluna      AS INTEGER            NO-UNDO.
DEFINE VARIABLE c-format      AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-data-type   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-valor-campo AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-query       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE h-utapi033    AS HANDLE             NO-UNDO.
DEFINE VARIABLE h-acomp       AS HANDLE             NO-UNDO.

{utp/ut-liter.i "Ponto Coleta" * }
ASSIGN c-label-coluna[1] = RETURN-VALUE.
{utp/ut-liter.i "Desc Ponto Coleta" * } 
ASSIGN c-label-coluna[2] = RETURN-VALUE.
{utp/ut-liter.i "Pto Coletivo?" * }
ASSIGN c-label-coluna[3] = RETURN-VALUE.
{utp/ut-liter.i "Propriedade" * }
ASSIGN c-label-coluna[4] = RETURN-VALUE.
{utp/ut-liter.i "Desc Propriedade" * }
ASSIGN c-label-coluna[5] = RETURN-VALUE.
{utp/ut-liter.i "Produtor" * }
ASSIGN c-label-coluna[6] = RETURN-VALUE.
{utp/ut-liter.i "Nome Produtor" * }
ASSIGN c-label-coluna[7] = RETURN-VALUE.
{utp/ut-liter.i "Respons†vel" * }
ASSIGN c-label-coluna[8] = RETURN-VALUE.
{utp/ut-liter.i "Rota" * }
ASSIGN c-label-coluna[9] = RETURN-VALUE.
{utp/ut-liter.i "Desc Rota" * }
ASSIGN c-label-coluna[10] = RETURN-VALUE.
{utp/ut-liter.i "KM Percurso" * }
ASSIGN c-label-coluna[11] = RETURN-VALUE.

ASSIGN  d-largura[1] = 15
        d-largura[2] = 30
        d-largura[3] = 12
        d-largura[4] = 20
        d-largura[5] = 30
        d-largura[6] = 15
        d-largura[7] = 30
        d-largura[8] = 12
        d-largura[9] = 12
        d-largura[10] = 30
        d-largura[11] = 15.

{utp/ut-liter.i "Sim" * }
ASSIGN c-sim-nao[1] = RETURN-VALUE.
{utp/ut-liter.i "N∆o" * }
ASSIGN c-sim-nao[2] = RETURN-VALUE.

{utp/ut-liter.i Relat¢rio_Produtores_do_Ponto_de_Coleta * } 
ASSIGN c-titulo-relat = RETURN-VALUE.

{utp/ut-liter.i Data_Emisss∆o *}
ASSIGN c-titulo-relat = RETURN-VALUE + ": " +  STRING(TODAY) + " - " + c-titulo-relat.

DEFINE TEMP-TABLE tt-param-planilha NO-UNDO
    FIELD descricao AS CHARACTER
    FIELD valor     AS CHARACTER.

