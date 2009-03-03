class BillIssue < ActiveRecord::Base
  # ATTRIBUTES ======================
  # t.integer :bill_id
  # t.integer :issue_id
  attr_accessor :issue_name
  attr_accessor :user_permissions
  
  # RELATIONSHIPS ===================
  def bill
    @bill ||= Bill.find_by_sql(
      "SELECT bills.* FROM 
      billtrack_data.bills
      WHERE bill_id = #{self.bill_id.to_i}"
    )
  end 
  def bill=( b )
    if b.class == String || b.class == Fixnum
      self.bill_id = b
    elsif b.class = Bill
      self.bill_id = b.id
    else
      raise ArgumentError, 'must be a bill of bill id'  
    end    
  end  
   
  belongs_to :issue
  
  # HOOKS =============================
  before_create :find_or_create_issue
  def find_or_create_issue
    if issue_name
      issue = Issue.find_by( :name => issue_name )
      unless issue 
        issue = Issue.create( :name => issue_name )
        issue.advance_status! if has_permissions?
      end
      self.issue_id = issue.id
      issue
    end  
  end
    
  # INSTANCE METHODS ===================
  
  # this method and the user_permissions accessor should probably be generalize and included 
  # in any suggestable model
  def has_permissions? 
    user_permissions && ( user_permissions.include?( :issues ) || user_permissions.include?( :admin ) )
  end   
end
