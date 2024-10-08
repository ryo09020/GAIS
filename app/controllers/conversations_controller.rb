class ConversationsController < ApplicationController
    def create
        conversation = Conversation.new(conversation_params)
        conversation.user_id = current_user.id
        if conversation.save
            redirect_to conversation_path(conversation.id)
        end
    end

    def show
        @conversation = Conversation.find(params[:id])  
        if @conversation.user_id == current_user.id
            @pre_system = current_user.chats.last.system if current_user.chats.last.present?
            @conversations = Conversation.where(user_id: current_user.id, model_id: @conversation.model_id)
            @new_conversation = Conversation.new
            @chats = current_user.chats.where(conversation_id: @conversation.id)
            @chat = Chat.new
        else
            redirect_to request.referer
        end
    end

    def destroy
        Conversation.find(params[:id]).destroy
        redirect_to users_path
    end
    
    
    def destroy_all
        Conversation.where(user_id: current_user.id).destroy_all
        redirect_to conversations_path
    end
    
    
    private
    
    def conversation_params
        params.require(:conversation).permit(:title, :model_id)
    end
end
