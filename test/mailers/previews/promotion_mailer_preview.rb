class PromotionMailerPreview < ActionMailer::Preview
  def approval_email
    PromotionMailer
      .with(approver: User.first, promotion: Promotion.first)
      .approval_email
  end
end
