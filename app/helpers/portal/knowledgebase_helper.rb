module Portal::KnowledgebaseHelper
  def status kb
    status = kb.status ? "Unapprove" : "Approve"
    link_to status, portal_knowledgebase_approve_question_path(id:kb.id), class:"btn btn-primary"
  end
end
