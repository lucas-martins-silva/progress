/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9017A 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9017a MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9017a.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Manutencao da transacao de Enderecamento WMS                              **
**                                                                                         **
**   Includes..: bcp/bc9106.i                                                              **
**                                                                                         **
********************************************************************************************/

/********************  Frame Fields Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE FrameFields  tt-ender-wms.cod-usuario      ~
                            tt-ender-wms.cod-coletor      ~
                            tt-ender-wms.cod-estabel      ~
                            tt-ender-wms.cod-local        ~
                            tt-ender-wms.des-endereco     ~
                            tt-ender-wms.num-documento    ~
                            tt-ender-wms.num-movimento    ~
                            tt-ender-wms.num-seq-item     ~
                            tt-ender-wms.num-box          ~
                            tt-ender-wms.num-tempo-inicio ~
                            tt-ender-wms.cod-equipamento  ~
                            tt-ender-wms.cod-item         ~
                            tt-ender-wms.qtd-item         ~
                            tt-ender-wms.num-box-lido     ~
                            tt-ender-wms.cod-embalagem    ~
                            tt-ender-wms.qtd-embalagem    ~
                            tt-ender-wms.qtd-embal-lidas  ~
                            tt-ender-wms.des-seriais      ~
                            tt-ender-wms.num-serial       ~
                            tt-ender-wms.dat-atualizacao  ~
                            tt-ender-wms.dat-transacao    

/********************  Frame Fields Preprocessor Definitions End  ***************/


/*****************  Name of TT Include Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE NameOfTTInclude bcp/bc9017.i
/*****************  Name of TT Include Preprocessor Definitions End  ************/


/*******************  Program Title Preprocessor Definitions Beg  ***************/
&GLOBAL-DEFINE ProgramBC9017A
/*******************  Program Title Preprocessor Definitions End  ***************/


/**************  Frame Number of Columns Preprocessor Definitions Beg  **********/
&GLOBAL-DEFINE FrameNumOfColumns 2
/**************  Frame Number of Columns Preprocessor Definitions End  **********/


/*****************  Geracao Etiquetas Preprocessor Definitions Beg  *************/
&GLOBAL-DEFINE TransactionProgram bc9017
/*****************  Geracao Etiquetas Preprocessor Definitions End  *************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE Table tt-ender-wms
/**********************  Table Preprocessor Definitions End  ********************/


/**********************  Table Preprocessor Definitions Beg  ********************/
&GLOBAL-DEFINE TransDetail vCodTransaction + ~
                          ' Usr: '  + String(tt-ender-wms.cod-usuario)                     + ~
                          ' Col: '  + String(tt-ender-wms.cod-coletor)                     + ~
                          ' Eqp: '  + String(tt-ender-wms.cod-equipamento)                 + ~
                          ' Doc: '  + String(tt-ender-wms.num-documento)                   + ~
                          ' Ser: '  + String(tt-ender-wms.num-serial,'99999999999999':U)   + ~
                          ' Dat: '  + String(Today,'99/99/9999':U)                         + ~
                          ' Hor: '  + String(time,'hh:mm:ss')

/**********************  Table Preprocessor Definitions End  ********************/


/**************  Fields Custom Display Preprocessor Definitions Beg  ************/
&GLOBAL-DEFINE CustomDisplayField01 
&GLOBAL-DEFINE CustomValueField01  
/**************  Fields Custom Display Preprocessor Definitions End  ************/

/**************  Fields Custom Formats Preprocessor Definitions Beg  ************/
/**************  Fields Custom Formats Preprocessor Definitions End  ************/
{bcp/bc9106.i}

