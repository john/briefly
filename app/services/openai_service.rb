class OpenaiService
  def initialize
    @client = OpenAI::Client.new(
      access_token: ENV['OPENAI_API_KEY']
    )
  end

  def generate_report(prompt, model = 'gpt-4', temperature = 0.7)
    response = @client.chat(
      parameters: {
        model: model,
        messages: [
          { role: "system", content: "You are an expert research report writer. Generate detailed, well-structured reports based on the provided prompts." },
          { role: "user", content: prompt }
        ],
        temperature: temperature,
        max_tokens: 2000
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue OpenAI::Error => e
    Rails.logger.error("OpenAI API Error: #{e.message}")
    raise
  end
end 