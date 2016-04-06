
declare @ID_Registrant int
declare @ID_Contact int
declare @DateEntered datetime
declare @ID_Anv_Hosp int
declare @ID_Anv_Hosp_Request int
declare @Rank int
declare @ConfirmFirstHospChoice bit
declare @ID_Package int
declare @TopBidder bit
declare @ThursdayConfirmed bit
declare @FridayConfirmed bit
declare @SaturdayConfirmed bit
declare @MaxHospGuests int
declare @TotalHospGuestsConfirmed int
declare @CurrentCount int
declare @TicketCount int

set @CurrentCount = 0
set @ThursdayConfirmed = 0
set @FridayConfirmed = 0
set @SaturdayConfirmed = 0

declare @ID_Event int
set @ID_Event = 2016 --set to 789 for texsting on my local db

--cursor for the registrants ordered by DateEntered ASC
declare c_registrants cursor for
select ID_Registrant, ID_Contact, DateEntered, ID_Package, TicketCount from registrants 
where ID_Event = @ID_Event and ID_Registrant in (select ID_Registrant from anv_Hosp_Requests) order by DateEntered asc

open c_registrants 
fetch next from c_registrants into @ID_Registrant, @ID_Contact, @DateEntered, @ID_Package, @TicketCount


--Loop though the registrants by DateEntered asc and check to see if they have hosp requests for each hosp 
while @@FETCH_STATUS = 0
begin

    --Does that package confirm the first hosp choice (VIP)
	select @ConfirmFirstHospChoice = isnull(ConfirmFirstHospChoice,0)
			from Packages where ID_Package = @ID_Package
	
	--Is the user a top bidder
	select @TopBidder = isnull(TopBidder,0) from Contacts where id_contact = @ID_Contact

	print('--------------------------- Starting registrant')
	print('@ID_Registrant = ' + cast(@ID_Registrant as varchar(20)))
	print('@ID_Contact = ' +  cast(@ID_Contact as varchar(20)))
	print('@DateEntered = ' +  cast(@DateEntered as varchar(20)))
	print('@ID_Package = ' +  cast(@ID_Package as varchar(20)))
	print('@ConfirmFirstHospChoice = ' +  cast(@ConfirmFirstHospChoice as varchar(20)))
	print('@TopBidder = ' +  cast(@TopBidder as varchar(20)))
	print('------------------------------------------------')

	--If they have thurday party requests
	if exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'T') and not exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'T' and status = 'confirmed')
	begin

		print('INSIDE: if exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = T) and not exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = T and status = confirmed)')
	    set @ThursdayConfirmed = 0
		declare c_thursday_requests cursor for
		select id_anv_hosp, RankValue, ID_anv_Hosp_Requests from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'T' order by RankValue asc

		open c_thursday_requests
		fetch next from c_thursday_requests into @ID_Anv_Hosp, @Rank, @ID_Anv_Hosp_Request
		--loop through Thurday parties
		print('@@FETCH_STATUS = ' + cast(@@FETCH_STATUS as varchar(20)))
		while @@FETCH_STATUS = 0
		begin
			print('c_thursday_requests iteration ------------------------------------------------')
			print('@ID_Anv_Hosp = ' +  cast(@ID_Anv_Hosp as varchar(20)))
			print('@Rank = ' +  cast( @Rank as varchar(20)))
			print('@ID_Anv_Hosp_Request = ' +  cast( @ID_Anv_Hosp_Request as varchar(20)))
			print('------------------------------------------------')
		
			if(@ThursdayConfirmed <> 1) -- if they have already been confirmed for this day, skip
			begin
				print('INSIDE: if(@ThursdayConfirmed <> 1)')
				--if the rank is one and the contact is a past successful bidder ot the package is flagged to give the registrant first choice, confirm them
				if(@Rank = 1 AND (@ConfirmFirstHospChoice = 1 OR @TopBidder = 1))
				begin
				print('INSIDE: if(@Rank = 1 AND (@ConfirmFirstHospChoice = 1 OR @TopBidder = 1))')
					update anv_Hosp_Requests set status = 'confirmed' where ID_anv_Hosp_Requests = @ID_Anv_Hosp_Request
					set @ThursdayConfirmed = 1
					select @CurrentCount = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')
					--select @CurrentCount = count(*) from anv_Hosp_Requests where ID_anv_Hosp = @ID_Anv_Hosp and status = 'confirmed'
					update anv_hosp set CurGuestCount = @CurrentCount where ID_Anv_Hosp = @ID_Anv_Hosp
				end
				else
				begin -- if not, check the confirmd count against the max guests for the 
				print('INSIDE else of: if(@Rank = 1 AND (@ConfirmFirstHospChoice = 1 OR @TopBidder = 1))')
					select @MaxHospGuests = isnull(MaxGuests,0) from anv_Hosp where ID_ANV_Hosp = @ID_ANV_Hosp
					select @TotalHospGuestsConfirmed = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')

					if((@TotalHospGuestsConfirmed + @TicketCount) <= @MaxHospGuests)
					begin
						print('inside if(@TotalHospGuestsConfirmed <= @MaxHospGuests)')
						update anv_Hosp_Requests set status = 'confirmed' where ID_anv_Hosp_Requests = @ID_Anv_Hosp_Request
						set @ThursdayConfirmed = 1
						select @CurrentCount = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')
						update anv_hosp set CurGuestCount = @CurrentCount where ID_Anv_Hosp = @ID_Anv_Hosp
					end
				end
			end
		  
			fetch next from c_thursday_requests into @ID_Anv_Hosp, @Rank, @ID_Anv_Hosp_Request
		end
		close c_thursday_requests
		deallocate c_thursday_requests
	 end
	 




	--If they have friday party requests
	if exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'F') and not exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'F' and status = 'confirmed')
	begin
		 set @FridayConfirmed = 0
		declare c_friday_requests cursor for
		select id_anv_hosp, RankValue, ID_anv_Hosp_Requests from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'F' order by RankValue asc

		open c_friday_requests
		fetch next from c_friday_requests into @ID_Anv_Hosp, @Rank, @ID_Anv_Hosp_Request
		--loop through friday parties
		while @@FETCH_STATUS = 0
		begin
		
			if(@FridayConfirmed <> 1) -- if they have already been confirmed for this day, skip
			begin
				--if the rank is one and the contact is a past successful bidder ot the package is flagged to give the registrant first choice, confirm them
				if(@Rank = 1 AND (@ConfirmFirstHospChoice = 1 OR @TopBidder = 1))
				begin
					update anv_Hosp_Requests set status = 'confirmed' where ID_anv_Hosp_Requests = @ID_Anv_Hosp_Request
					set @FridayConfirmed = 1
					select @CurrentCount = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')
					update anv_hosp set CurGuestCount = @CurrentCount where ID_Anv_Hosp = @ID_Anv_Hosp
				end
				else
				begin -- if not, check the confirmd count against the max guests for the party
					select @MaxHospGuests = isnull(MaxGuests,0) from anv_Hosp where ID_ANV_Hosp = @ID_ANV_Hosp
					select @TotalHospGuestsConfirmed = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')

					if((@TotalHospGuestsConfirmed + @TicketCount) <= @MaxHospGuests)
					begin
						update anv_Hosp_Requests set status = 'confirmed' where ID_anv_Hosp_Requests = @ID_Anv_Hosp_Request
						set @FridayConfirmed = 1
						select @CurrentCount = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')
						update anv_hosp set CurGuestCount = @CurrentCount where ID_Anv_Hosp = @ID_Anv_Hosp
					end
				end
			end
		 
			fetch next from c_friday_requests into @ID_Anv_Hosp, @Rank, @ID_Anv_Hosp_Request
		end
		close c_friday_requests
		deallocate c_friday_requests
	 end


	 
	--If they have saturday party requests
	if exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'S') and not exists(select * from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'S' and status = 'confirmed')
	begin
	    set @SaturdayConfirmed = 0
		declare c_saturday_requests cursor for
		select id_anv_hosp, RankValue, ID_anv_Hosp_Requests from anv_Hosp_Requests where ID_Registrant = @ID_Registrant and Day = 'S' order by RankValue asc

		open c_saturday_requests
		fetch next from c_saturday_requests into @ID_Anv_Hosp, @Rank, @ID_Anv_Hosp_Request
		--loop through friday parties
		while @@FETCH_STATUS = 0
		begin
		
			if(@SaturdayConfirmed <> 1) -- if they have already been confirmed for this day, skip
			begin
				--if the rank is one and the contact is a past successful bidder ot the package is flagged to give the registrant first choice, confirm them
				if(@Rank = 1 AND (@ConfirmFirstHospChoice = 1 OR @TopBidder = 1))
				begin
					update anv_Hosp_Requests set status = 'confirmed' where ID_anv_Hosp_Requests = @ID_Anv_Hosp_Request
					set @SaturdayConfirmed = 1
					select @CurrentCount = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')
					update anv_hosp set CurGuestCount = @CurrentCount where ID_Anv_Hosp = @ID_Anv_Hosp
				end
				else
				begin -- if not, check the confirmd count against the max guests for the party
					select @MaxHospGuests = isnull(MaxGuests,0) from anv_Hosp where ID_ANV_Hosp = @ID_ANV_Hosp
					select @TotalHospGuestsConfirmed = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')

					if((@TotalHospGuestsConfirmed + @TicketCount) <= @MaxHospGuests)
					begin
						update anv_Hosp_Requests set status = 'confirmed' where ID_anv_Hosp_Requests = @ID_Anv_Hosp_Request
						set @SaturdayConfirmed = 1
						select @CurrentCount = sum(TicketCount) from Registrants where id_event = 2016 and id_registrant in (select id_registrant from anv_hosp_requests where id_anv_hosp = @ID_Anv_Hosp and status = 'confirmed')
						update anv_hosp set CurGuestCount = @CurrentCount where ID_Anv_Hosp = @ID_Anv_Hosp
					end
				end
			end
		 
			fetch next from c_saturday_requests into @ID_Anv_Hosp, @Rank, @ID_Anv_Hosp_Request
		end
		close c_saturday_requests
		deallocate c_saturday_requests
	 end
fetch next from c_registrants into @ID_Registrant, @ID_Contact, @DateEntered, @ID_Package, @TicketCount
end

close c_registrants
deallocate c_registrants