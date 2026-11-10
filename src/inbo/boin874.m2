/***************************************************************************************
boin874.m2
Parametros: {1} - c¢digo da mensagem
            {2} - texto da mensagem
            {3} - YES/NO. Se for erro e ‚ para parar o processo, deve informar NO
***************************************************************************************/

CREATE msg-ret-nfe.
ASSIGN msg-ret-nfe.ch-acesso-comp-nfe = bf{&TableName}.cod-chave-aces-nfse
       msg-ret-nfe.idi-orig-trad      = 2
       msg-ret-nfe.dt-msg             = TODAY
       msg-ret-nfe.hr-msg             = STRING(TIME, "HH:MM:SS")
       msg-ret-nfe.log-ativo          = YES
       msg-ret-nfe.cd-msg             = {1}
       msg-ret-nfe.texto-msg          = {2}
       msg-ret-nfe.seq-msg            = NEXT-VALUE(seq-msg-ret-nfe)
       msg-ret-nfe.usuario            = c-seg-usuario
       l-ok                           = {3}.

IF NOT({3}) THEN
    LEAVE blocoNota.

