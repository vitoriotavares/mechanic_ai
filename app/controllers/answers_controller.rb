class AnswersController < ApplicationController
  def new
    @question = Question.last
    @answer = Answer.new(question_id: params[:question_id])
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user

    respond_to do |format|
      if @answer.save
        format.html { redirect_to @answer.question, notice: "Answer was successfully created." }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def load
    response.headers["Content-Type"] = "text/event-stream"
      client = OpenAI::Client.new()
      client.chat(
        parameters: {
          model: "gpt-4o",
          messages: [
            # { role: "system", content: "Você é um engenheiro mecanico de automoveis com muitos anos de experiencia com veiculos de diversas marcas, responda de maneira elucidativa e simples o problema para um usuário leigo qual possivel problema(s), como ele poderá proceder para a resolução do problema, se é um problema grave,  se há maneiras de contornar paliativamente e uma estimativa de gastos do problema a seguir" },
            # { role: "user", content: "Tenho um #{@question.mark_model}, ele tem #{@question.km} rodados e é do ano #{@question.year} e esse é meu problema: #{@question.problem}" }
            { role: "user", content: "Descreva resumidamente um personagem simples" }
          ],
          temperature: 0.7,
          stream: proc do |chunk, _bytesize|
            content = chunk.dig("choices", 0, "delta", "content")
            response.stream.write "data: #{content.strip}\n\n"
          end
        }
      )
  rescue => e
    Rails.logger.error("Error during streaming: #{e.message}")
  ensure
    response.stream.close
  end

  private

  def answer_params
    params.require(:answer).permit(:question_id, :response)
  end
end
