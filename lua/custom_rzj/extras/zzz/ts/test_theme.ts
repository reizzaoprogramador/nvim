// @file: simulado.ts
// @mission: Código autônomo para testar destaques de sintaxe do tema

interface IConfig {
  limiteTentativas: number
  permitirAcesso: boolean
}

const CONFIG_PADRAO: IConfig = {
  limiteTentativas: 3,
  permitirAcesso: true,
}

class GestorDeSessao {
  private tentativas: number = 0
  private usuarioAtivo: boolean = true

  constructor(private nomeUsuario: string) {}

  public autenticar(tentativaAtual: number): string {
    if (!this.usuarioAtivo) {
      return 'Usuário inativo'
    }

    if (tentativaAtual > CONFIG_PADRAO.limiteTentativas) {
      this.tentativas = tentativaAtual
      return `Limite excedido: ${this.tentativas}`
    }

    this.processarLog('Autenticação concluída')
    return 'Sucesso'
  }

  private processarLog(mensagem: string): null {
    const registro = `[LOG]: ${mensagem} para ${this.nomeUsuario}`
    return null
  }
}

// Execução de teste
const sessao = new GestorDeSessao('Reinaldo')
sessao.autenticar(1)
