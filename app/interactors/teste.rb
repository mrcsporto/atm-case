# app/interactors/create_article.rb 
class CreateArticle 
  include Interactor 

  def call 
    context.article = Article.new(context.params) 

    if context.article.save
      unless context.article.draft? 
        Member.where(subscribed: true).each do |member| 
          SendMailJob.perform_async(member.id, article.id) 
        end 
      end 
    else 
      context.fail! unless context.article.valid? 
    end 
  end 
end 

# app/controllers/articles_controller.rb 
class ArticlesController < ApplicationController 
  def create 
    result = CreateArticle.call(params: article_params) 

    if result.success? 
      redirect_to result.article, notice: 'Success!' 
    else
      @article = result.article 
      render :new 
    end 
  end 
end