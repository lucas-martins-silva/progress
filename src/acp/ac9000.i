/*************************************************************************
***
***  acp/ac9000.i - Defini‡Æo temp-table da tabela Cotas.
***
**************************************************************************/
    
define temp-table tt-cotas
    field cod-estabel      like cotas.cod-estabel
    field cod-canal-venda like cotas.cod-canal-venda
    field cd-produto      like cotas.cd-produto
    field cod-gr-cli      like cotas.cod-gr-cli
    field nome-abrev      like emitente.nome-abrev
    field nome-ab-reg     like cotas.nome-ab-reg
    field nome-mic-reg    like cotas.nome-mic-reg
    field cod-rep         like cotas.cod-rep
    field dt-inicial      like cotas.dt-inicial
    field dt-final        like cotas.dt-final
    field prevista        like cotas.qt-prevista
    field pedida          like cotas.qt-pedida
    field faturada        like cotas.qt-faturada
    field ped-canc        like cotas.qt-ped-canc
    field fat-canc        like cotas.qt-fat-canc
    field ped-susp        like cotas.qt-ped-susp
    field original        like cotas.qt-original
    field solicitado      like cotas.qt-solicitado
    field cota-liberada   like cotas.cota-liberada
    field tp-contr        like par-cota.tipo-controle
    field nr-pontos       like base-cota.nr-pontos
    &IF DEFINED (bf_dis_adm_cotas) &THEN   /* INICIO PREPROCESSADOR */ 
       field reprovada    like cotas.qt-ped-reprov 
    &ENDIF
    INDEX codigo IS PRIMARY UNIQUE 
          cod-estabel
          cod-canal-venda
          cod-gr-cli
          nome-abrev
          nome-ab-reg
          nome-mic-reg
          cod-rep
          cd-produto
          dt-inicial.

/* Fim de Include */
