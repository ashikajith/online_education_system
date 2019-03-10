module Portal::QuestionsHelper
	def question_action(question)
		links = ""
    if can? :read, Question
		  links += link_to "show", id:question.id, action:'show'
		  links += " | "
    end
    if can? :update, Question  
		  links += link_to "edit", id:question.id, action:'edit'
		  links += " | "
    end
    if can? :destroy, Question  
		  links += link_to "delete", portal_question_path(question),confirm:"Are you sure", method:'delete'
    end  
		return links
	end
end
