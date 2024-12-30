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

    begin
      client = OpenAI::Client.new
      buffer = ""

      client.chat(
        parameters: {
          model: "gpt-4o",
          messages: [
            { role: "user", content: "Descreva resumidamente um personagem simples" }
          ],
          temperature: 0.7,
          stream: proc do |chunk, _bytesize|
            content = chunk.dig("choices", 0, "delta", "content")
            buffer += content

            if content.match?(/\s/)
              response.stream.write "#{buffer.strip}"
              buffer.clear
            end
          end
        }
      )
    rescue => e
      Rails.logger.error("Error during streaming: #{e.message}")
      response.stream.write "data: [Error] #{e.message}\n\n"
    ensure
      response.stream.write "event: done\ndata: [Stream Closed]\n\n"
      response.stream.close
    end
  end


  private

  def answer_params
    params.require(:answer).permit(:question_id, :response)
  end
end
