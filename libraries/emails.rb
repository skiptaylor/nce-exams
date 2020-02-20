class Email

	def self.welcome to, name, email, policy, item, price
	
		body = ''
		body << "<p>Dear #{name},</p>"
		body << "<p>Welcome - you have successfully created an account at counselorexams.com! You will receive a separate email confirming the details of your purchase.</p>"
		body << "<p>Thank you for choosing us as a source for your exam preparatory materials. We are confident our prep services can help you pass your counselor licensure exam, because they have helped thousands of previous customers do just that.</p>"
		body << "<h3>Access Instructions:</h3>"
		body << "<p>To access your account profile, which lists the products you have purchased and provides access to your online services, go to: http://counselorexams.com/sign-in</p>"
		body << "<p><strong>NOTE: You are responsible for maintaining the confidentiality of the log-in credentials and are solely responsible for all activities that occur under your account. Your account is ONLY FOR PERSONAL USE. You may NOT authorize others to use the account, and you may NOT assign or otherwise transfer the account to any other person or entity. You agree to safeguard the login information used to access this site. You agree not to disclose or share your login information with any third party. You authorize DGA/CTC to assume that any user accessing the site with your log-in credentials is you, the authorized user.</strong></p>"
    body << "<p>Your account email address is: #{email}</p>"
		body << "<p>If you do not remember the password you used when you created your account, you may use the 'forgot password' link at the above URL to change it.</p>"
		
		
		if policy == 'nce'
      body << "<h3>Satisfaction Guarantee Return Policy:</h3>"
			body << "<p>The customer has <em>3 days</em> from the purchase date to review the purchased <em>online services</em>, including online exams and eBook, to confirm that it is what he or she expected. If the customer has purchased a hard-copy of the NCE  Study Guide, he or she has <em>3 days from the date of delivery of the Study Guide</em>. If unhappy with the content for any reason, the customer is required to notify CTC within these 3 days either by phone or e-mail that he/she is requesting a refund and will be returning the Study Guide, if applicable. Further, to qualify for a refund, the customer <em>may not have completed any online exam; they are allowed access for review only</em> if they wish to request a Satisfaction Guarantee refund. Upon proper notification, CTC will turn off access to these online services, and a refund will be issued. For those customers who have purchased the hard-copy, it is required the hard-copy Study Guide be returned to CTC in good condition. Once CTC has received the hard-copy, a refund will be issued (excludes all shipping and any applicable sales tax). Note: The return expense is the responsibility of the customer.</p>"
		end
		
		if policy == 'ncmhce'
      body << "<h3>Satisfaction Guarantee Return Policy:</h3>"
			body << "<p>The customer has 3 days from the purchase date to review the purchased <em>online services,</em> including online Scenarios and eBook, to confirm that it is what he or she expected. If the customer has purchased a hard-copy of the NCMHCE Supplement, he or she has <em>3 days from the date of delivery of the Supplement</em>. If unhappy with the content for any reason, the customer is required to notify CTC within these 3 days either by phone or e-mail that he/she is requesting a refund and will be returning the Supplement, if applicable. Further, to qualify for a refund, the customer <em>may not have accessed more than 3 online scenarios</em>. Upon proper notification, CTC will turn off access to these online services, and a refund will be issued. For those customers who have purchased the hard-copy, it is required the hard-copy Supplement be returned to CTC in good condition. Once CTC has received the hard-copy, a refund will be issued (excludes all shipping and any applicable sales tax). Note: The return expense is the responsibility of the customer.</p>"
		end
	
		body << "<p>Thank you for your purchase at counselorexams.com!</p>"
		body << "<p>The online products you have purchased should be immediately available at your profile page. If you purchased a hard-copy of any study materials, you will receive a separate email from FedEx with a tracking number once it is shipped. (Shipping usually occurs within 2 business days.)</p>"
		body << "<h3>Your Purchase</h3>"
		body << "<p>#{item}: $#{price}</p>"
    
		body << "<p>If you have any questions about your purchase, please contact us at http://counselorexams.com/feedback.</p>"
		body << "<p>We are also available by phone during the business hours of 9:30 AM to 4:30 PM Eastern time, Monday through Friday, at 888-326-9229.</p>"
	
		Pony.mail(
			headers: { 'Content-Type' => 'text/html' },
			to: to,
			from: 'no-reply@counselorexams.com',
			subject: 'Welcome to counselorexams.com',
			body: body
		)
	end
	    
  def self.secondchance to, name

    body = ''
    body << "<p>Dear #{name},</p>"
    body << "<p>Thank you for your purchase at counselorexams.com!</p>"
    body << "<p>As a reminder, you purchased the NCMHCE Starter Package, which provides access to any 12 of our 36 online practice scenarios.</p>"
    body << "<p>Tip: as you decide which scenarios to access, please be aware that our scenarios get progressively more complex/difficult as the number of the scenario increases. Therefore, to get the most out of your purchase, you may want to try a range of the scenarios, versus just the 'first 12'.
</p>"
    body << "<p>Depending on your specific situation and relative readiness for the exam, you may find the Starter Package is sufficient to prepare for the NCMHCE. However, we do have customers who state they wished they had purchased the Full Package shortly after their Starter purchase. For these customers, we are now offering a 'second chance' to save!</p>"
    body << "<h3>Second Chance Offer!</h3>" 
    body << "<p>Should you decide you want access to <b>all 47</b> of the scenarios within two weeks of your original purchase date, you may upgrade your Starter Package to our Full Package for the price difference of $154. (This would equal the same price as if you had ordered the Full Package originally.)</p>"
    body << "<p>Note this is in contrast to the pricing of ordering additional scenarios after the two week period has passed, when the upgrade package(s) cost $95.00 per set of 12 scenarios (for a total of $285 for access to all 36 of the scenarios once the two weeks is up) plus an additional $70 to purchase the 10 Exam Scenarios, which is included in our Full Package.
</p>"
    body << "<p>To upgrade your package from Starter to Full to save this $106.00, sign-in to your account and select the 'Upgrade to Full Package now for $154' button on your Profile page</p>"
    body << "<p>Good luck on your exam!</p>"

    Pony.mail(
      headers: { 'Content-Type' => 'text/html' },
      to: to,
      from: 'no-reply@counselorexams.com',
      subject: 'counselorexams.com NCMHCE Second Chance Upgrade',
      body: body
    )
  end

end