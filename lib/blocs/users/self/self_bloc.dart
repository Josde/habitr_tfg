import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:habitr_tfg/data/classes/user.dart';
import 'package:habitr_tfg/utils/constants.dart';
import 'package:meta/meta.dart';

import '../../../data/classes/streak.dart';

part 'self_event.dart';
part 'self_state.dart';

class SelfBloc extends Bloc<SelfEvent, SelfState> {
  SelfBloc() : super(SelfInitial()) {
    on<LoadSelfEvent>(_onLoadSelf);
    on<ReloadSelfEvent>(_onReloadSelf);
  }

  void _onLoadSelf(SelfEvent event, Emitter<SelfState> emitter) async {
    print('_onLoadSelf');
    emitter.call(SelfLoading());
    try {
      if (supabase.auth.currentUser == null) {
        emitter.call(SelfError('User is not logged in.'));
        return;
      }
      final myselfResponse = await supabase
          .from('profiles')
          .select()
          .eq('uuid', supabase.auth.currentUser!.id)
          .single() as Map;
      print(myselfResponse);
      var myself = User.fromJson(myselfResponse);
      final streakResponse = await supabase
              .from('streak')
              .select()
              .eq('profile_id', supabase.auth.currentUser!.id)
              .or('id.eq.${myself.maxStreakId},id.eq.${myself.currentStreakId}')
          as List;
      print(streakResponse);
      for (var streak in streakResponse) {
        if (streak['id'] == myself.maxStreakId) {
          myself.maxStreak = Streak.fromJson(streak as Map);
        } else {
          myself.currentStreak = Streak.fromJson(streak as Map);
        }
      }
      emitter.call(SelfLoaded(self: myself, lastLoadTime: DateTime.now()));
    } catch (e) {
      print(e);
    }
  }

  void _onReloadSelf(ReloadSelfEvent event, Emitter<SelfState> emit) async {
    // Same as above, but keeps the previous state accessible meanwhile.
    emit.call(SelfReloading(self: this.state.self));
    try {
      if (supabase.auth.currentUser == null) {
        emit.call(SelfError('User is not logged in.'));
        return;
      }
      final myselfResponse = await supabase
          .from('profiles')
          .select()
          .eq('uuid', supabase.auth.currentUser!.id)
          .single() as Map;
      var myself = User.fromJson(myselfResponse);
      emit.call(SelfLoaded(self: myself, lastLoadTime: DateTime.now()));
    } catch (e) {
      print(e);
    }
  }
}
