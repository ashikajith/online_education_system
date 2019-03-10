module Portal::QuestionPapersHelper
	def question_paper_action(question_paper)
		links = ""
    if can? :read, QuestionPaper
		  links += link_to "show", portal_question_paper_path(question_paper)
		  links += " | "
    end
    if can? :update, QuestionPaper
		  links += link_to "edit", edit_portal_question_paper_path(question_paper)
		  links += " | "
    end
    if can? :destroy, QuestionPaper  
		  links += link_to "delete", portal_question_paper_path(question_paper),confirm:"Are you sure", method:'delete'
		end
    return links
	end
end
