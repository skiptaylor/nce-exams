namespace :taxes do

	desc 'Imports new tax rates'
	task :import do
    # ??? Find something along the lines of first_of_update ???
    Tax.destroy
    CSV.open('./data/taxes.csv', { headers: true }) do |area|
      area.each do |a|
        Tax.create zip: a['ZipCode'], rate: a['CombinedRate'].to_f
      end
    end
	end

end