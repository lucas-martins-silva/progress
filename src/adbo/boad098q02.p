&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOAD098Q02 2.00.00.004} /*** "010004" 14/12/2023 14:14:31  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BOAD098Q02 MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) ‚ um programa PROGRESS 
                 que cont‚m a l¢gica de neg¢cio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOAD098q02
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName emitente
&GLOBAL-DEFINE TableLabel Emitente
&GLOBAL-DEFINE QueryName qr{&TableName} 

{adbo/boad098q02.i RowObject}
{adbo/boad098q02.i tt-emitente}      

/* DBO-XML-BEGIN */
/*:T Pre-processadores para ativar XML no DBO */
/*:T Retirar o comentario para ativar 
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE XMLTopic           /*:T Topico da Mensagem enviada ao Message Broker, geralmente o nome da tabela */
&GLOBAL-DEFINE XMLTableName       /*:T Nome da tabela que deve ser usado como TAG no XML */ 
&GLOBAL-DEFINE XMLTableNameMult   /*:T Nome da tabela no plural. Usado para multiplos registros */ 
&GLOBAL-DEFINE XMLPublicFields    /*:T Lista dos campos (c1,c2) que podem ser enviados via XML. Ficam fora da listas os campos de especializacao da tabela */ 
&GLOBAL-DEFINE XMLKeyFields       /*:T Lista dos campos chave da tabela (c1,c2) */
&GLOBAL-DEFINE XMLExcludeFields   /*:T Lista de campos a serem excluidos do XML quando PublicFields = "" */

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (m‚todo Receive Message) */
&GLOBAL-DEFINE QueryDefault       /*:T Nome da Query que d  acessos a todos os registros, exceto os exclu¡dos pela constraint de seguran‡a. Usada para receber uma mensagem XML. */
&GLOBAL-DEFINE KeyField1 cust-num /*:T Informar os campos da chave quando o Progress nÆo conseguir resolver find {&TableName} OF RowObject. */
*/
/* DBO-XML-END */

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
/*:T--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
      

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*:T--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}


/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/*---Defini‡Æo das vari veis */

DEFINE VARIABLE i-cod-emitente-ini AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-cod-emitente-fim AS INTEGER    NO-UNDO.
DEFINE VARIABLE c-nome-abrev-ini   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-nome-abrev-fim   AS CHARACTER  NO-UNDO.

{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}

    DEFINE TEMP-TABLE RowErrorsFrotas no-undo
           field ErrorSequence as integer
           field ErrorNumber   as integer
           field ErrorDescription as char
           field ErrorParameters as char
           field ErrorType       as char
           field Errorhelp       as char
           field Errorsubtype    as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 14.83
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
define input  parameter c-field as char.
        define output parameter c-value as char.

        case c-field:
            when "agencia":U then c-value = RowObject.agencia.
            when "atividade":U then c-value = RowObject.atividade.
            when "bairro":U then c-value = RowObject.bairro.
            when "bairro-cob":U then c-value = RowObject.bairro-cob.
            when "caixa-postal":U then c-value = RowObject.caixa-postal.
            when "categoria":U then c-value = RowObject.categoria.
            when "cgc":U then c-value = RowObject.cgc.
            when "cgc-cob":U then c-value = RowObject.cgc-cob.
            when "char-1":U then c-value = RowObject.char-1.
            when "char-2":U then c-value = RowObject.char-2.
            when "cidade":U then c-value = RowObject.cidade.
            when "cidade-cob":U then c-value = RowObject.cidade-cob.
            when "cod-cacex":U then c-value = RowObject.cod-cacex.
            when "cod-suframa":U then c-value = RowObject.cod-suframa.
            when "conta-corren":U then c-value = RowObject.conta-corren.
            when "contato[1]":U then c-value = RowObject.contato[1].
            when "contato[2]":U then c-value = RowObject.contato[2].
            when "cx-post-cob":U then c-value = RowObject.cx-post-cob.
            when "endereco":U then c-value = RowObject.endereco.
            when "endereco-cob":U then c-value = RowObject.endereco-cob.
            when "estado":U then c-value = RowObject.estado.
            when "estado-cob":U then c-value = RowObject.estado-cob.
            when "inf-complementar":U then c-value = RowObject.inf-complementar.
            when "ins-est-cob":U then c-value = RowObject.ins-est-cob.
            when "ins-estadual":U then c-value = RowObject.ins-estadual.
            when "ins-municipal":U then c-value = RowObject.ins-municipal.
            when "insc-subs-trib":U then c-value = RowObject.insc-subs-trib.
            when "linha-produt":U then c-value = RowObject.linha-produt.
            when "nat-ope-ext":U then c-value = RowObject.nat-ope-ext.
            when "nat-operacao":U then c-value = RowObject.nat-operacao.
            when "nome-abrev":U then c-value = RowObject.nome-abrev.
            when "nome-emit":U then c-value = RowObject.nome-emit.
            when "nome-matriz":U then c-value = RowObject.nome-matriz.
            when "nome-mic-reg":U then c-value = RowObject.nome-mic-reg.
            when "nome-tr-red":U then c-value = RowObject.nome-tr-red.
            when "nr-tabpre":U then c-value = RowObject.nr-tabpre.
            when "pais":U then c-value = RowObject.pais.
            when "pais-cob":U then c-value = RowObject.pais-cob.
            when "ramal[1]":U then c-value = RowObject.ramal[1].
            when "ramal[2]":U then c-value = RowObject.ramal[2].
            when "ramal-fac":U then c-value = RowObject.ramal-fac.
            when "ramal-fax":U then c-value = RowObject.ramal-fax.
            when "ramal-modem":U then c-value = RowObject.ramal-modem.
            when "telef-fac":U then c-value = RowObject.telef-fac.
            when "telef-modem":U then c-value = RowObject.telef-modem.
            when "telefax":U then c-value = RowObject.telefax.
            when "telefone[1]":U then c-value = RowObject.telefone[1].
            when "telefone[2]":U then c-value = RowObject.telefone[2].
            when "telex":U then c-value = RowObject.telex.
            when "user-libcre":U then c-value = RowObject.user-libcre.
            when "zip-cob-code":U then c-value = RowObject.zip-cob-code.
            when "zip-code":U then c-value = RowObject.zip-code.        
            &if defined(bf-mat-comex) &then            
                when "obs-entrega[1]":U then c-value = RowObject.obs-entrega[1].
                when "obs-entrega[2]":U then c-value = RowObject.obs-entrega[2].        
                when "observacoes[1]":U then c-value = RowObject.observacoes[1].
                when "observacoes[2]":U then c-value = RowObject.observacoes[2].  
                when "emissao-ped":U then c-value = RowObject.emissao-ped.        
                when "identific":U then c-value = RowObject.identific.        
                when "natureza":U then c-value = RowObject.natureza.        
                when "tp-pagto":U then c-value = RowObject.tp-pagto.                
                when "u-char-1":U then c-value = RowObject.u-char-1.        
                when "u-char-2":U then c-value = RowObject.u-char-2.                    
            &else        
                when "cep":U then c-value = RowObject.cep.        
                when "cep-cob":U then c-value = RowObject.cep-cob.            
                when "check-sum":U then c-value = RowObject.check-sum.            
                when "cn-codigo":U then c-value = RowObject.cn-codigo.            
                when "cod-entrega":U then c-value = RowObject.cod-entrega.            
                when "e-mail":U then c-value = RowObject.e-mail.            
                when "endereco2":U then c-value = RowObject.endereco2.            
                when "home-page":U then c-value = RowObject.home-page.            
                when "obs-entrega":U then c-value = RowObject.obs-entrega.            
                when "observacoes":U then c-value = RowObject.observacoes.            
            &endif

            otherwise return error.
        end case.
    end procedure.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 

    procedure getDecField:
        define input  parameter c-field as char.
        define output parameter c-value as decimal.

        case c-field:
            when "bonificacao":U then c-value = RowObject.bonificacao.
            when "compr-period":U then c-value = RowObject.compr-period.
            when "dec-1":U then c-value = RowObject.dec-1.
            when "dec-2":U then c-value = RowObject.dec-2.
            when "lim-adicional":U then c-value = RowObject.lim-adicional.
            when "lim-credito":U then c-value = RowObject.lim-credito.
            when "per-max-canc":U then c-value = RowObject.per-max-canc.
            when "per-minfat":U then c-value = RowObject.per-minfat.
            when "taxa-financ":U then c-value = RowObject.taxa-financ.
            when "vl-min-ad":U then c-value = RowObject.vl-min-ad.
            &if defined(bf-mat-comex) &then            
                when "u-dec-1":U then c-value = RowObject.u-dec-1.
                when "u-dec-2":U then c-value = RowObject.u-dec-2.        
            &else        
                when "val-quota-media":U then c-value = RowObject.val-quota-media.        
                when "valor-minimo":U then c-value = RowObject.valor-minimo.            
                when "vl-max-devol":U then c-value = RowObject.vl-max-devol.            
            &endif
            otherwise return error.
        end case.
    end procedure.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 

    procedure getIntField:
        define input  parameter c-field as char.
        define output parameter c-value as integer.

        case c-field:
            when "bx-acatada":U then c-value = RowObject.bx-acatada.
            when "cod-banco":U then c-value = RowObject.cod-banco.
            when "cod-cond-pag":U then c-value = RowObject.cod-cond-pag.
            when "cod-emitente":U then c-value = RowObject.cod-emitente.
            when "cod-gr-cli":U then c-value = RowObject.cod-gr-cli.
            when "cod-gr-forn":U then c-value = RowObject.cod-gr-forn.
            when "cod-mensagem":U then c-value = RowObject.cod-mensagem.
            when "cod-rep":U then c-value = RowObject.cod-rep.
            when "cod-tip-ent":U then c-value = RowObject.cod-tip-ent.
            when "cod-transp":U then c-value = RowObject.cod-transp.
            when "end-cobranca":U then c-value = RowObject.end-cobranca.
            when "esp-pd-venda":U then c-value = RowObject.esp-pd-venda.
            when "gera-difer":U then c-value = RowObject.gera-difer.
            when "hora-fim":U then c-value = RowObject.hora-fim.
            when "hora-ini":U then c-value = RowObject.hora-ini.
            when "ind-atraso":U then c-value = RowObject.ind-atraso.
            when "ind-cre-cli":U then c-value = RowObject.ind-cre-cli.
            when "ind-dif-atrs-1":U then c-value = RowObject.ind-dif-atrs-1.
            when "ind-dif-atrs-2":U then c-value = RowObject.ind-dif-atrs-2.
            when "ind-div-atraso":U then c-value = RowObject.ind-div-atraso.
            when "ind-moeda-tit":U then c-value = RowObject.ind-moeda-tit.
            when "ins-banc[1]":U then c-value = RowObject.ins-banc[1].
            when "ins-banc[2]":U then c-value = RowObject.ins-banc[2].
            when "int-1":U then c-value = RowObject.int-1.
            when "int-2":U then c-value = RowObject.int-2.
            when "istr":U then c-value = RowObject.istr.
            when "mod-prefer":U then c-value = RowObject.mod-prefer.
            when "modalidade":U then c-value = RowObject.modalidade.
            when "nr-copias-ped":U then c-value = RowObject.nr-copias-ped.
            when "nr-dias":U then c-value = RowObject.nr-dias.
            when "nr-dias-taxa":U then c-value = RowObject.nr-dias-taxa.
            when "nr-mesina":U then c-value = RowObject.nr-mesina.
            when "nr-peratr":U then c-value = RowObject.nr-peratr.
            when "nr-titulo":U then c-value = RowObject.nr-titulo.
            when "perc-fat-ped":U then c-value = RowObject.perc-fat-ped.
            when "port-prefer":U then c-value = RowObject.port-prefer.
            when "portador":U then c-value = RowObject.portador.
            when "prox-ad":U then c-value = RowObject.prox-ad.
            when "tip-cob-desp":U then c-value = RowObject.tip-cob-desp.
            when "tp-desp-padrao":U then c-value = RowObject.tp-desp-padrao.
            when "tp-inspecao":U then c-value = RowObject.tp-inspecao.
            when "tp-qt-prg":U then c-value = RowObject.tp-qt-prg.
            when "tp-rec-padrao":U then c-value = RowObject.tp-rec-padrao.
            when "ven-domingo":U then c-value = RowObject.ven-domingo.
            when "ven-feriado":U then c-value = RowObject.ven-feriado.
            when "ven-sabado":U then c-value = RowObject.ven-sabado.
            &if defined(bf-mat-comex) &then        
                when "ind-aval[1]":U then c-value = RowObject.ind-aval[1].
                when "ind-aval[2]":U then c-value = RowObject.ind-aval[2].       
                when "cep":U then c-value = RowObject.cep.        
                when "cep-cob":U then c-value = RowObject.cep-cob.
                when "u-int-1":U then c-value = RowObject.u-int-1.        
                when "u-int-2":U then c-value = RowObject.u-int-2.            
            &else        
                when "cod-canal-venda":U then c-value = RowObject.cod-canal-venda.        
                when "cod-classif-cliente":U then c-value = RowObject.cod-classif-cliente.            
                when "cod-classif-fornec":U then c-value = RowObject.cod-classif-fornec.            
                when "cod-isencao":U then c-value = RowObject.cod-isencao.                
                when "cod-parceiro-edi":U then c-value = RowObject.cod-parceiro-edi.            
                when "cod-tax":U then c-value = RowObject.cod-tax.            
                when "dias-comp":U then c-value = RowObject.dias-comp.            
                when "emissao-ped":U then c-value = RowObject.emissao-ped.            
                when "estoque":U then c-value = RowObject.estoque.            
                when "flag-pag":U then c-value = RowObject.flag-pag.            
                when "identific":U then c-value = RowObject.identific.            
                when "ind-abrange-aval":U then c-value = RowObject.ind-abrange-aval.            
                when "ind-aval":U then c-value = RowObject.ind-aval.            
                when "ind-aval-embarque":U then c-value = RowObject.ind-aval-embarque.            
                when "ind-emit-retencao":U then c-value = RowObject.ind-emit-retencao.            
                when "ind-sit-emitente":U then c-value = RowObject.ind-sit-emitente.            
                when "moeda-libcre":U then c-value = RowObject.moeda-libcre.                        
                when "natureza":U then c-value = RowObject.natureza.            
                when "nr-cheque-devol":U then c-value = RowObject.nr-cheque-devol.            
                when "nr-dias-atraso":U then c-value = RowObject.nr-dias-atraso.            
                when "nr-tab-progr":U then c-value = RowObject.nr-tab-progr.            
                when "periodo-devol":U then c-value = RowObject.periodo-devol.            
                when "resumo-mp":U then c-value = RowObject.resumo-mp.            
                when "tp-pagto":U then c-value = RowObject.tp-pagto.            
                when "tr-ar-valor":U then c-value = RowObject.tr-ar-valor.            
            &endif
            otherwise return error.
        end case.
    end procedure.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 

    procedure getDateField:
        define input  parameter c-field as char.
        define output parameter c-value as date.

        case c-field:
            when "data-implant":U then c-value = RowObject.data-implant.
            when "data-taxa":U then c-value = RowObject.data-taxa.
            when "dt-fim-cred":U then c-value = RowObject.dt-fim-cred.
            when "dt-lim-cred":U then c-value = RowObject.dt-lim-cred.
            when "dt-ult-venda":U then c-value = RowObject.dt-ult-venda.
            &if defined(bf-mat-comex) &then            
            &else        
                when "data-1":U then c-value = RowObject.data-1.        
                when "data-2":U then c-value = RowObject.data-2.            
            &endif        
            otherwise return error.
        end case.
    end procedure.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 

    procedure getLogField:
        define input  parameter c-field as char.
        define output parameter c-value as logical.

        case c-field:
            when "contrib-icms":U then c-value = RowObject.contrib-icms.
            when "emite-bloq":U then c-value = RowObject.emite-bloq.
            when "emite-etiq":U then c-value = RowObject.emite-etiq.
            when "forn-exp":U then c-value = RowObject.forn-exp.
            when "gera-ad":U then c-value = RowObject.gera-ad.
            when "ind-apr-cred":U then c-value = RowObject.ind-apr-cred.
            when "ind-cred-abat":U then c-value = RowObject.ind-cred-abat.
            when "ind-fat-par":U then c-value = RowObject.ind-fat-par.
            when "ind-lib-estoque":U then c-value = RowObject.ind-lib-estoque.
            when "ind-rendiment":U then c-value = RowObject.ind-rendiment.
            when "log-1":U then c-value = RowObject.log-1.
            when "log-2":U then c-value = RowObject.log-2.
            &if defined(bf-mat-comex) &then            
                when "resumo-mp":U then c-value = RowObject.resumo-mp.        
                when "tr-ar-valor":U then c-value = RowObject.tr-ar-valor.       
                when "u-log-1":U then c-value = RowObject.u-log-1.       
                when "u-log-2":U then c-value = RowObject.u-log-2.               
            &else        
                when "agente-retencao":U then c-value = RowObject.agente-retencao.        
                when "calcula-multa":U then c-value = RowObject.calcula-multa.            
                when "ind-licenciador":U then c-value = RowObject.ind-licenciador.                    
                when "item-cli":U then c-value = RowObject.item-cli.            
                when "percepcao":U then c-value = RowObject.percepcao.            
                when "prog-emit":U then c-value = RowObject.prog-emit.            
                when "recebe-inf-sci":U then c-value = RowObject.recebe-inf-sci.            
            &endif        
            otherwise return error.
        end case.
    end procedure.

&ANALYZE-SUSPEND   _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 

PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice codigo
  Parameters:  
               retorna valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-emitente = RowObject.cod-emitente.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice codigo
  Parameters:  
               recebe valor do campo cod-emitente
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-emitente LIKE emitente.cod-emitente NO-UNDO.

    FIND FIRST bfemitente WHERE 
        bfemitente.cod-emitente = pcod-emitente NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfemitente THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfemitente)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByCodigo DBOProgram 
PROCEDURE OpenQueryByCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF i-cod-emitente-ini = i-cod-emitente-fim THEN
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE 
               {&TableName}.cod-emitente = i-cod-emitente-ini AND
               &IF DEFINED(bf-dis-comex) &THEN                                             
                  {&TableName}.identific <> "F":U and
                  ({&TableName}.natureza   =  "E":U or {&TableName}.natureza = "T":U) NO-LOCK
                    BY {&TableName}.cod-emitente.
               &else
                  {&TableName}.identific <> 2 and
                  ({&TableName}.natureza   =  3 or {&TableName}.natureza = 4) NO-LOCK
                    BY {&TableName}.cod-emitente.
               &ENDIF
ELSE
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
               {&TableName}.cod-emitente >= i-cod-emitente-ini AND
               {&TableName}.cod-emitente <= i-cod-emitente-fim AND 
               &IF DEFINED(bf-dis-comex) &THEN
                  {&TableName}.identific <> "F":U and
                  ({&TableName}.natureza   =  "E":U or {&TableName}.natureza = "T":U) NO-LOCK
                    BY {&TableName}.cod-emitente.
               &else
                  {&TableName}.identific <> 2 and
                  ({&TableName}.natureza   =  3 or {&TableName}.natureza = 4) NO-LOCK
                    BY {&TableName}.cod-emitente.
               &ENDIF
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryByNome DBOProgram 
PROCEDURE OpenQueryByNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF c-nome-abrev-ini = c-nome-abrev-fim THEN 
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
               {&TableName}.nome-abrev = c-nome-abrev-ini AND
               &IF DEFINED(bf-dis-comex) &THEN
                  {&TableName}.identific <> "F":U and
                  ({&TableName}.natureza   =  "E":U or {&TableName}.natureza = "T":U) NO-LOCK
                    BY {&TableName}.nome-abrev
                    BY {&TableName}.cod-emitente.
               &else
                  {&TableName}.identific <> 2 and
                  ({&TableName}.natureza   =  3 or {&TableName}.natureza = 4) NO-LOCK
                    BY {&TableName}.nome-abrev
                    BY {&TableName}.cod-emitente.
               &ENDIF  
ELSE
    OPEN QUERY {&QueryName} FOR EACH {&TableName} WHERE
               {&TableName}.nome-abrev >= c-nome-abrev-ini AND
               {&TableName}.nome-abrev <= c-nome-abrev-fim AND
               &IF DEFINED(bf-dis-comex) &THEN
                  {&TableName}.identific <> "F":U and
                  ({&TableName}.natureza   =  "E":U or {&TableName}.natureza = "T":U) NO-LOCK
                    BY {&TableName}.nome-abrev
                    BY {&TableName}.cod-emitente.
               &else
                  {&TableName}.identific <> 2 and
                  ({&TableName}.natureza   =  3 or {&TableName}.natureza = 4) NO-LOCK
                    BY {&TableName}.nome-abrev
                    BY {&TableName}.cod-emitente.
               &ENDIF
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQueryMain DBOProgram 
PROCEDURE OpenQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
OPEN QUERY {&QueryName} FOR EACH {&TableName} NO-LOCK.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintByCodigo DBOProgram 
PROCEDURE SetConstraintByCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-cod-emitente-ini LIKE emitente.cod-emitente.
DEFINE INPUT PARAMETER p-cod-emitente-fim LIKE emitente.cod-emitente.

ASSIGN i-cod-emitente-ini = p-cod-emitente-ini 
       i-cod-emitente-fim = p-cod-emitente-fim.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintByNome DBOProgram 
PROCEDURE SetConstraintByNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-nome-abrev-ini LIKE emitente.nome-abrev.
DEFINE INPUT PARAMETER p-nome-abrev-fim LIKE emitente.nome-abrev.
DEFINE INPUT PARAMETER p-cod-emitente-ini LIKE emitente.cod-emitente.
DEFINE INPUT PARAMETER p-cod-emitente-fim LIKE emitente.cod-emitente.

ASSIGN c-nome-abrev-ini = p-nome-abrev-ini
       c-nome-abrev-fim = p-nome-abrev-fim
       i-cod-emitente-ini = p-cod-emitente-ini 
       i-cod-emitente-fim = p-cod-emitente-fim.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetConstraintMain DBOProgram 
PROCEDURE SetConstraintMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateDeleteFrotas DBOProgram 
PROCEDURE validateDeleteFrotas :
/*------------------------------------------------------------------------------
  Purpose: Valida as tabelas de Frotas    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define variable h-abapi008 as handle  no-undo.
define variable iErro      as integer no-undo.
define variable lValida    as logical no-undo.
define variable i-cont     as integer no-undo.



assign lValida = no.
do i-cont = 1 to 5:
    if i-cont <> 3
    and i-cont <> 4 then do:
        run cdp/cd9902.p (input i-cont).
        if return-value = "OK":U then do:
            assign lValida = yes.
            leave.
        end.
    end.
end.
if lValida then do:
    /** Passa o rowid para API de Frotas **/
    run abp/abapi008.p persistent set h-abapi008 (input RowObject.r-rowid).
    /** Valida‡äes de Frotas **/
    run validateEmitente in h-abapi008 (input RowObject.cod-emitente).
    if return-value = "NOK":U then do:
        empty temp-table RowErrorsFrotas.
        /** Busca os erros ocorridos em frotas **/
        run getRowErrors in h-abapi008 (output table RowErrorsFrotas).
        assign iErro = 0.
        /** Se ocorreram erros noproduto padrÆo, busca a £ltima sequˆncia **/
        for last RowErrors no-lock:
            assign iErro = RowErrors.ErrorSequence.
        end.
        /** Percorre os erros ocorridos em frotas **/
        for each RowErrorsFrotas no-lock:
            /** Cria os erros no produto padrÆo **/
            create RowErrors.
            buffer-copy RowErrorsFrotas except ErrorSequence to RowErrors
                assign RowErrors.ErrorSequence = iErro + 1
                       iErro                   = RowErrors.ErrorSequence.
        end.
        empty temp-table RowErrorsFrotas.
    end.
    /** Elimina a API da mem¢ria **/
    if valid-handle(h-abapi008) then
        delete procedure h-abapi008.
end.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    if pType = "DELETE":U then do:
        run validateDeleteFrotas in this-procedure.
    end.
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

