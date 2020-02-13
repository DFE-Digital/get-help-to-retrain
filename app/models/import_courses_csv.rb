class ImportCoursesCsv

  def doit
    puts "Starting import at #{Time.now}"
    puts "Importing courses..."
    fetch_courses
    puts "Importing providers..."
    fetch_providers
    puts "Importing opportunities..."
    fetch_opportunities
    puts "Importing venues..."
    fetch_venues
    puts "Importing opa10..."
    fetch_opa10s
    puts "Importing opp_start_dates..."
    fetch_opp_start_dates
    puts "Import ended at #{Time.now}"
  end

  def fetch_courses
    Coursescsv.delete_all

    data = CSV.read("O_COURSES.csv", col_sep: ",", headers: true)

    data.each do |res|
      Coursescsv.create(
        course_id: res[0],
        provider_id: res[1],
        lad_id: res[2],
        provider_course_title: res[3],
        course_summary: res[4],
        provider_course_id: res[5],
        course_url: res[6],
        booking_url: res[7],
        entry_requirements: res[8],
        assessment_method: res[9],
        equipment_required: res[10],
        qualification_type: res[11],
        qualification_title: res[12],
        qualification_level: res[13],
        ldcs1: res[14],
        ldcs2: res[15],
        ldcs3: res[16],
        ldcs4: res[17],
        ldcs5: res[18],
        data_source: res[19],
        ucas_tariff: res[20],
        qual_ref_authority: res[21],
        qual_reference: res[22],
        course_type_id: res[23],
        date_created: res[24],
        date_updated: res[25],
        status: res[26],
        awarding_org_name: res[27],
        updated_by: res[28],
        created_by: res[29],
        qualification_type_code: res[30],
        data_type: res[31],
        sys_data: res[32],
        date_updated_copy_over: res[33],
        date_created_copy_over: res[34],
        dfe_funded: res[35]
      )
    end

    Coursescsv.first.delete
  end

  def fetch_providers
    data = CSV.read("C_PROVIDERS.csv", col_sep: ",", headers: true)

    Providerscsv.delete_all

    data.each do |res|
      Providerscsv.create(
        provider_id: res[0],
        provider_name: res[1],
        ukprn: res[2],
        provider_type_id: res[3],
        provider_type_description: res[4],
        email: res[5],
        website: res[6],
        phone: res[7],
        fax: res[8],
        prov_trading_name: res[9],
        prov_legal_name: res[10],
        lsc_supplier_no: res[11],
        prov_alias: res[12],
        date_created: res[13],
        date_updated: res[14],
        ttg_flag: res[15],
        tqs_flag: res[16],
        ies_flag: res[17],
        status: res[18],
        updated_by: res[19],
        created_by: res[20],
        address_1: res[21],
        address_2: res[22],
        town: res[23],
        county: res[24],
        postcode: res[25],
        sys_data_source: res[26],
        date_updated_copy_over: res[27],
        date_created_copy_over: res[28],
        dfe_provider_type_id: res[29],
        dfe_provider_type_description: res[30],
        dfe_local_authority_code: res[31],
        dfe_local_authority_description: res[32],
        dfe_region_code: res[33],
        dfe_region_description: res[34],
        dfe_establishment_type_code: res[35],
        dfe_establishment_type_description: res[36]
      )
    end
  end

  def fetch_venues
    data = CSV.read("C_VENUES.csv", col_sep: ",", headers: true)

    Venuescsv.delete_all

    data.each do |res|
      Venuescsv.create(
        provider_id: res[0],
        venue_id: res[1],
        venue_name: res[2],
        prov_venue_id: res[3],
        phone: res[4],
        address_1: res[5],
        address_2: res[6],
        town: res[7],
        county: res[8],
        postcode: res[9],
        email: res[10],
        website: res[11],
        fax: res[12],
        facilities: res[13]
      )
    end
  end

  def fetch_opportunities
    data = CSV.read("O_OPPORTUNITIES.csv", col_sep: ",", headers: true)

    Opportunitiescsv.delete_all

    data.each do |res|
      Opportunitiescsv.create(
        opportunity_id: res[0],
        provider_opportunity_id: res[1],
        price: res[2],
        price_description: res[3],
        duration_value: res[4],
        duration_units: res[5],
        duration_description: res[6],
        start_date_description: res[7],
        end_date: res[8],
        study_mode: res[9],
        attendance_mode: res[10],
        attendance_pattern: res[11],
        language_of_instruction: res[12],
        language_of_assessment: res[13],
        places_available: res[14],
        enquire_to: res[15],
        apply_to: res[16],
        apply_from: res[17],
        apply_until: res[18],
        apply_unti_desc: res[19],
        url: res[20],
        timetable: res[21],
        course_id: res[22],
        venue_id: res[23],
        apply_throughout_year: res[24],
        eis_flag: res[25],
        region_name: res[26],
        date_created: res[27],
        date_update: res[28],
        status: res[29],
        updated_by: res[30],
        created_by: res[31],
        opportunity_summary: res[32],
        region_id: res[33],
        sys_data_source: res[34],
        date_updated_copy_over: res[35],
        date_created_copy_over: res[36],
        offered_by: res[37],
        dfe_funded: res[38]
      )
    end
  end

  def fetch_opa10s
    data = CSV.read("O_OPP_A10.csv", col_sep: ",", headers: true)
    Oppa10csv.delete_all

    data.each do |res|
      Oppa10csv.create(
        opportunity_id: res[0],
        a10_code: res[1]
      )
    end
  end

  def fetch_opp_start_dates
    data = CSV.read("O_OPP_START_DATES.csv", col_sep: ",", headers: true)

    Oppstartdatescsv.delete_all

    data.each do |res|
      Oppstartdatescsv.create(
        opportunity_id: res[0],
        start_date: res[1],
        places_available: res[2],
        date_format: res[3]
      )
    end
  end

  def fetch_aims
    data = CSV.read("S_LEARNING_AIMS.csv", col_sep: ",", headers: true, encoding: 'ISO-8859-1')

    Slearningaimscsv.delete_all

    data.each do |res|
      Slearningaimscsv.create(
        lara_release_version: res[0],
        lara_download_date: res[1],
        learning_aim_ref: res[2],
        learning_aim_title: res[3],
        learning_aim_type_desc: res[4],
        awarding_body_name: res[5],
        entry_sub_level_desc: res[6],
        notional_level_v2_code: res[7],
        notional_level_v2_desc: res[8],
        credit_based_type_desc: res[9],
        qca_glh: res[10],
        sector_lead_body_desc: res[11],
        level2_entitlement_cat_desc: res[12],
        level3_entitlement_cat_desc: res[13],
        skills_for_life: res[14],
        skills_for_life_type_desc: res[15],
        ssa_tier1_code: res[16],
        ssa_tier1_desc: res[17],
        ssa_tier2_code: res[18],
        ssa_tier2_desc: res[19],
        ldcs_code_code: res[20],
        accreditation_start_date: res[21],
        accreditation_end_date: res[22],
        certification_end_date: res[23],
        ffa_credit: res[24],
        indep_living_skills: res[25],
        er_app_status: res[26],
        er_ttg_status: res[27],
        adultlr_status: res[28],
        otherfunding_nonfundedstatus: res[29],
        learning_aim_type: res[30],
        qual_reference_authority: res[31],
        qualification_reference: res[32],
        qualification_title: res[33],
        qualification_level: res[34],
        qualification_type: res[35],
        date_updated: res[36],
        qualification_type_code: res[37],
        status: res[38],
        qualification_level_code: res[39],
        date_created: res[40],
        source_system_reference: res[41],
        section_96_apprvl_status_code: res[42],
        section_96_apprvl_status_desc: res[43],
        sklls_fundng_apprv_stat_code: res[44],
        sklls_fundng_apprv_stat_desc: res[45]
      )
    end
  end
end