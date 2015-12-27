require 'rails_helper'

describe EtsPdf::Etl::PreProcess do
  it_behaves_like 'Pipeline'

  describe '#execute' do
    let(:pdf_folder) { 'tmp/pdf_directory' }
    let(:pdf_pattern) { "#{pdf_folder}/**/*" }
    subject { described_class.new(pdf_pattern) }

    before do
      (1..6).each { |index| FileUtils.mkdir_p(Rails.root.join(pdf_folder, "#{index}.pdf")) }
      (4..6).each { |index| FileUtils.mkdir_p(Rails.root.join(pdf_folder, "#{index}.txt")) }
    end
    after { FileUtils.rm_rf(pdf_folder) }

    it 'converts every pdf to txt, unless it already exists' do
      (1..3).each do |index|
        pdf_path = Rails.root.join(pdf_folder, "#{index}.pdf").to_s
        expect(IO).to receive(:popen).with("pdftotext -enc UTF-8 -layout #{pdf_path}")
      end

      expect(subject.execute).to eq(pdf_pattern)
    end
  end
end
