class RemovePageTextFromInDesignDocs < ActiveRecord::Migration
  def change
    remove_columns :in_design_docs, :first_page_text, :second_and_third_page_text
  end
end
