define temp-table tt-param no-undo
    field destino            as   integer
    field arquivo            as   char format "x(35)":U
    field cod-estabel        like estabelec.cod-estabel
    field cod-layout         like layout-restdo-analis.cod-layout
    field rd-amostra-pto-col AS   integer   /* 1 - considera pto-coleta coletivos 2 - único para cada pto-coleta*/
    field cod-period         like fechto-produt-period.cod-period
    field arq-saida          as   char      /* local onde será gravada planilha exportada */    
    field usuario            as   char format "x(12)":U
    field data-exec          as   date
    field hora-exec          as   integer
    field classifica         as   integer
    field desc-classifica    as   char format "x(40)":U
    field modelo             AS   char format "x(35)":U
    /*Alterado 15/02/2005 - tech1007 - Criado campo lógico para verificar se o RTF foi habilitado*/
    field l-habilitaRtf      as LOG.
    /*Fim alteracao 15/02/2005*/

define temp-table tt-digita no-undo
    field cod-rota         like pto-rota-coleta.cod-rota
    field cod-pto-coleta   like pto-rota-coleta.cod-pto-coleta
    field cdn-produt-rural like produt-pto-coleta.cdn-produt-rural
    field des-pto-coleta   like pto-coleta.des-pto-coleta
    field nome-emit        like emitente.nome-emit
    FIELD cdn-seq          LIKE pto-rota-coleta.cdn-seq.

define buffer b-tt-digita for tt-digita.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def temp-table tt-conteudo-planilha no-undo
   field i-coluna           as integer
   field i-cdn-campo-layout as integer
   field campo              as character
   field des-campo          as character
   field conteudo           as character.
